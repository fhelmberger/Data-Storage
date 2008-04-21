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


our $VERSION = '0.01';


use base qw(Data::Storage Class::Accessor::Complex);


__PACKAGE__->mk_scalar_accessors(qw(
    dbh dbname dbuser dbpass AutoCommit RaiseError PrintError LongReadLen
    HandleError schema_prefix
));



use constant DEFAULTS => (
    AutoCommit    => 0,
    RaiseError    => 1,
    PrintError    => 0,
    LongReadLen   => 4_096_000,
    HandleError   => Error::Hierarchy::Internal::DBI->handler,
    schema_prefix => '',
);


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
    $self->log->debug('storage [%s] is %s',
        $self->dbname,
        $is_connected ? 'connected' : 'not connected');
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

Data::Storage - generic abstract storage mechanism

=head1 SYNOPSIS

None yet (see below).

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<datastorage> tag.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-data-storage@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

Heinz Ekker C<< ek@univie.ac.at >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

