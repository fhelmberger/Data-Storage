package Data::Storage::DBI::Postgres;

# $Id$

use strict;
use warnings;
use Error::Hierarchy::Util 'assert_defined';


our $VERSION = '0.08';


use base qw(Data::Storage::DBI Class::Accessor::Complex);


use constant connect_string_dbi_id => 'Pg';


sub connect {
    my $self = shift;

    $self->SUPER::connect(@_);
    # FIXME: is this the right place and the right way for setting utf-8 encoding?
    $self->dbh->{pg_enable_utf8} = 1;
}


sub test_setup {
    my $self = shift;
    $self->connect;
    $self->disconnect;
}


sub last_id {
    my ($self, $sequence_name) = @_;
    $self->dbh->last_insert_id(undef,undef,undef,undef,
			       {sequence => $sequence_name});
}


sub next_id {
    my ($self, $sequence_name) = @_;

    unless ($sequence_name) {
	throw Error::Hierarchy::Internal::ValueUndefined;
    }

    my $sth = $self->prepare("
	SELECT NEXTVAL('$sequence_name')");
    $sth->execute;
    my ($next_id) = $sth->fetchrow_array;
    $sth->finish;
    $next_id;
}


sub trace {
    my $self = shift;
    $self->dbh->trace(@_);
}


# Database type-specifc rewrites

sub rewrite_query_for_dbd {
    my ($self, $query) = @_;

    $query =~ s/<USER>/CURRENT_USER/g;
    $query =~ s/<NOW>/NOW()/g;
    $query =~ s/<NEXTVAL>\((.*?)\)/NEXTVAL('$1')/g;
    $query =~ s/<BOOL>\((.*?)\)/expression::bool($1)/g;

    $query;
}


1;


__END__



=head1 NAME

Data::Storage::DBI::Postgres - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage::DBI::Postgres->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4



=back

Data::Storage::DBI::Postgres inherits from L<Data::Storage::DBI>.

The superclass L<Data::Storage::DBI> defines these methods and functions:

    AutoCommit(), AutoCommit_clear(), HandleError(), HandleError_clear(),
    LongReadLen(), LongReadLen_clear(), PrintError(), PrintError_clear(),
    RaiseError(), RaiseError_clear(), clear_AutoCommit(),
    clear_HandleError(), clear_LongReadLen(), clear_PrintError(),
    clear_RaiseError(), clear_dbh(), clear_dbhost(), clear_dbname(),
    clear_dbpass(), clear_dbuser(), clear_port(), clear_schema_prefix(),
    commit(), connect_string(), dbh(), dbh_clear(), dbhost(),
    dbhost_clear(), dbname(), dbname_clear(), dbpass(), dbpass_clear(),
    dbuser(), dbuser_clear(), disconnect(), get_connect_options(),
    is_connected(), lazy_connect(), port(), port_clear(), prepare(),
    rewrite_query(), rollback(), schema_prefix(), schema_prefix_clear(),
    signature()

The superclass L<Data::Storage> defines these methods and functions:

    new(), clear_log(), clear_rollback_mode(), create(), id(),
    initialize_data(), log(), log_clear(), rollback_mode(),
    rollback_mode_clear(), rollback_mode_set(), set_rollback_mode(),
    setup()

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

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2004-2008 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

