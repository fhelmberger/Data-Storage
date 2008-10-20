package Data::Storage::DBI;

# $Id: DBI.pm 13653 2007-10-22 09:11:20Z gr $
#
# Mixin class for storages based on a transactional RDBMS. When deriving from
# this class, put it before Data::Storage in 'use base' so that its
# connect() and disconnect() methods are found before the generic ones from
# Data::Storage.

use strict;
use warnings;
use DBI ':sql_types';
use Data::Storage::DBI::Unrealized;
use Data::Storage::Statement;
use Error::Hierarchy::Util 'assert_defined';
use Error::Hierarchy::Internal::DBI;
use Error ':try';


our $VERSION = '0.09';


use base qw(Data::Storage Class::Accessor::Complex);


__PACKAGE__->mk_scalar_accessors(qw(
    dbh dbname dbuser dbpass dbhost port AutoCommit RaiseError PrintError
    LongReadLen HandleError schema_prefix));



use constant DEFAULTS => (
    AutoCommit    => 0,
    RaiseError    => 1,
    PrintError    => 0,
    LongReadLen   => 4_096_000,
    HandleError   => Error::Hierarchy::Internal::DBI->handler,
    schema_prefix => '',
);


# Subclasses that construct the connect string as given below can simply set
# the connect_string_dbi_id; others have to override connect_string().

use constant connect_string_dbi_id => '?';

sub connect_string {
    my $self = shift;
    my $s = sprintf "dbi:%s:dbname=%s",
        $self->connect_string_dbi_id, $self->dbname;
    $s .= ';host=' . $self->dbhost if $self->dbhost;
    $s .= ';port=' . $self->port   if $self->port;
    $s;
}


sub get_connect_options {
    my $self = shift;
    { RaiseError  => $self->RaiseError,
      PrintError  => $self->PrintError,
      AutoCommit  => $self->AutoCommit,
      LongReadLen => $self->LongReadLen,
      HandleError => $self->HandleError,
    }
}


sub is_connected {
    my $self = shift;
    my $is_connected = $self->dbh && (
         ref($self->dbh) eq 'DBI::db'
      || ref($self->dbh) eq 'Apache::DBI::db'
    );

    # No logging unless it's necessary - this is called often and is expensive

    # $self->log->debug('storage [%s] is %s',
    #     $self->dbname,
    #     $is_connected ? 'connected' : 'not connected');

    $is_connected;
}


sub connect {
    my $self = shift;

    return if $self->is_connected;

    assert_defined $self->$_, sprintf "called without %s argument.", $_
        for qw/dbname dbuser dbpass/;

    $self->log->debug('connecting to storage [%s] as [%s/%s]',
        $self->dbname,
        $self->dbuser,
        $self->dbpass
    );

    try {
        $self->dbh(DBI->connect(
            $self->connect_string,
            $self->dbuser,
            $self->dbpass,
            $self->get_connect_options,
        ));
    } catch Error with {
        my $E = shift;

        $! = 0;
        if ($self->dbh && ref($self->dbh) eq 'DBI::db') {
            $self->set_rollback_mode;
            $self->disconnect;
        }

        throw Error::Hierarchy::Internal::CustomMessage(
            custom_message => sprintf "couldn't connect to storage [%s (%s/%s)]: %s",
                $self->dbname,
                $self->dbuser,
                $self->dbpass,
                $E
        );
    };
}


sub disconnect {
    my $self = shift;
    return unless $self->is_connected;
    $self->rollback_mode ? $self->rollback : $self->commit;
    $self->log->debug('disconnecting from storage [%s]', $self->dbname);
    $self->dbh->disconnect;
    $self->clear_dbh;
}


sub rollback {
    my $self = shift;
    $self->dbh->rollback;
    $self->log->debug('did rollback');
}


sub commit {
    my $self = shift;
    return if $self->rollback_mode;

    # avoid "commit ineffective with AutoCommit enabled" error
    return if $self->AutoCommit;

    $self->dbh->commit;
    $self->log->debug('did commit');
}


sub lazy_connect {
    my $self = shift;
    return if $self->is_connected;
    $self->dbh(Data::Storage::DBI::Unrealized->new(callback => $self));
}


# Statement handles are wrapped in a special class that forwards most method
# calls directly to the statement handle but does some special things like
# stringifying potential value objects passed to bind_param.
#
# If you have a number of registry distributions (like we have NICAT, EnumAT,
# CarrierEnumAT etc.), you are probably going to use similar database
# schemata. We have a lot of tables that are the same in any registry database
# and they only differ in the table name prefix. For example, the table where
# the possible TLDs are stored is called cea_tld in CarrierEnumAT, eat_tld in
# EnumAT and so on. Therefore, we support a mechanism where you can use a
# speclal placeholder in your SQL statements where the database schema's
# prefix should be substituted.
#
# For example:
#
#   SELECT tld_code FROM <P>_tld
#
# where <P> will be replaced by the schema prefix (given in the schema_prefix
# constant).
#
# This way we can have generic statements that still work in different
# database schemata. It's a little bit like generics in C++ and Java except
# that here we don't abstract over types, but schema names.

sub prepare {
    my ($self, $query) = @_;
    Data::Storage::Statement->new(
        sth => $self->dbh->prepare($self->rewrite_query($query))
    );
}


sub prepare_named {
    my ($self, $name, $query) = @_;

    our %cache;
    $cache{$name} ||= $self->rewrite_query($query);

    Data::Storage::Statement->new(
        sth => $self->dbh->prepare($cache{$name})
    );
}


# Do nothing here; subclasses can override it to rename tables and columns,
# for example. rewrite_query() is for a specific storage implementation;
# rewrite_query_for_dbd() is for rewriting queries depending on the database
# type. For example, the current user is called 'user' in Oracle and
# 'CURRENT_USER' in PostgreSQL.

sub rewrite_query {
    my ($self, $query) = @_;

    $query = $self->rewrite_query_for_dbd($query);

    my $prefix = $self->schema_prefix;
    $query =~ s/<P>/$prefix/g;

    $query;
}


sub rewrite_query_for_dbd {
    my ($self, $query) = @_;
    $query;
}


sub signature {
    my $self = shift;
    sprintf "%s,dbname=%s,dbuser=%s",
        $self->SUPER::signature(), $self->dbname, $self->dbuser;
}


1;


__END__



=head1 NAME

Data::Storage::DBI - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage::DBI->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4

=item AutoCommit

    my $value = $obj->AutoCommit;
    $obj->AutoCommit($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item AutoCommit_clear

    $obj->AutoCommit_clear;

Clears the value.

=item HandleError

    my $value = $obj->HandleError;
    $obj->HandleError($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item HandleError_clear

    $obj->HandleError_clear;

Clears the value.

=item LongReadLen

    my $value = $obj->LongReadLen;
    $obj->LongReadLen($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item LongReadLen_clear

    $obj->LongReadLen_clear;

Clears the value.

=item PrintError

    my $value = $obj->PrintError;
    $obj->PrintError($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item PrintError_clear

    $obj->PrintError_clear;

Clears the value.

=item RaiseError

    my $value = $obj->RaiseError;
    $obj->RaiseError($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item RaiseError_clear

    $obj->RaiseError_clear;

Clears the value.

=item clear_AutoCommit

    $obj->clear_AutoCommit;

Clears the value.

=item clear_HandleError

    $obj->clear_HandleError;

Clears the value.

=item clear_LongReadLen

    $obj->clear_LongReadLen;

Clears the value.

=item clear_PrintError

    $obj->clear_PrintError;

Clears the value.

=item clear_RaiseError

    $obj->clear_RaiseError;

Clears the value.

=item clear_dbh

    $obj->clear_dbh;

Clears the value.

=item clear_dbhost

    $obj->clear_dbhost;

Clears the value.

=item clear_dbname

    $obj->clear_dbname;

Clears the value.

=item clear_dbpass

    $obj->clear_dbpass;

Clears the value.

=item clear_dbuser

    $obj->clear_dbuser;

Clears the value.

=item clear_port

    $obj->clear_port;

Clears the value.

=item clear_schema_prefix

    $obj->clear_schema_prefix;

Clears the value.

=item dbh

    my $value = $obj->dbh;
    $obj->dbh($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item dbh_clear

    $obj->dbh_clear;

Clears the value.

=item dbhost

    my $value = $obj->dbhost;
    $obj->dbhost($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item dbhost_clear

    $obj->dbhost_clear;

Clears the value.

=item dbname

    my $value = $obj->dbname;
    $obj->dbname($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item dbname_clear

    $obj->dbname_clear;

Clears the value.

=item dbpass

    my $value = $obj->dbpass;
    $obj->dbpass($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item dbpass_clear

    $obj->dbpass_clear;

Clears the value.

=item dbuser

    my $value = $obj->dbuser;
    $obj->dbuser($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item dbuser_clear

    $obj->dbuser_clear;

Clears the value.

=item port

    my $value = $obj->port;
    $obj->port($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item port_clear

    $obj->port_clear;

Clears the value.

=item schema_prefix

    my $value = $obj->schema_prefix;
    $obj->schema_prefix($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item schema_prefix_clear

    $obj->schema_prefix_clear;

Clears the value.

=back

Data::Storage::DBI inherits from L<Data::Storage>.

The superclass L<Data::Storage> defines these methods and functions:

    new(), clear_log(), clear_rollback_mode(), create(), id(),
    initialize_data(), log(), log_clear(), rollback_mode(),
    rollback_mode_clear(), rollback_mode_set(), set_rollback_mode(),
    setup(), test_setup()

The superclass L<Class::Accessor::Complex> defines these methods and
functions:

    mk_abstract_accessors(), mk_array_accessors(), mk_boolean_accessors(),
    mk_class_array_accessors(), mk_class_hash_accessors(),
    mk_class_scalar_accessors(), mk_concat_accessors(),
    mk_forward_accessors(), mk_hash_accessors(), mk_integer_accessors(),
    mk_new(), mk_object_accessors(), mk_scalar_accessors(),
    mk_set_accessors(), mk_singleton()

The superclass L<Class::Accessor> defines these methods and functions:

    _carp(), _croak(), _mk_accessors(), accessor_name_for(),
    best_practice_accessor_name_for(), best_practice_mutator_name_for(),
    follow_best_practice(), get(), make_accessor(), make_ro_accessor(),
    make_wo_accessor(), mk_accessors(), mk_ro_accessors(),
    mk_wo_accessors(), mutator_name_for(), set()

The superclass L<Class::Accessor::Installer> defines these methods and
functions:

    install_accessor()

The superclass L<Class::Accessor::Constructor> defines these methods and
functions:

    _make_constructor(), mk_constructor(), mk_constructor_with_dirty(),
    mk_singleton_constructor()

The superclass L<Data::Inherited> defines these methods and functions:

    every_hash(), every_list(), flush_every_cache_by_key()

The superclass L<Class::Accessor::Constructor::Base> defines these methods
and functions:

    STORE(), clear_dirty(), clear_hygienic(), clear_unhygienic(),
    contains_hygienic(), contains_unhygienic(), delete_hygienic(),
    delete_unhygienic(), dirty(), dirty_clear(), dirty_set(),
    elements_hygienic(), elements_unhygienic(), hygienic(),
    hygienic_clear(), hygienic_contains(), hygienic_delete(),
    hygienic_elements(), hygienic_insert(), hygienic_is_empty(),
    hygienic_size(), insert_hygienic(), insert_unhygienic(),
    is_empty_hygienic(), is_empty_unhygienic(), set_dirty(),
    size_hygienic(), size_unhygienic(), unhygienic(), unhygienic_clear(),
    unhygienic_contains(), unhygienic_delete(), unhygienic_elements(),
    unhygienic_insert(), unhygienic_is_empty(), unhygienic_size()

The superclass L<Tie::StdHash> defines these methods and functions:

    CLEAR(), DELETE(), EXISTS(), FETCH(), FIRSTKEY(), NEXTKEY(), SCALAR(),
    TIEHASH()

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<datastorage> tag.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<<bug-data-storage@rt.cpan.org>>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2004-2008 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

