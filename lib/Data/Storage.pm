package Data::Storage;

# $Id: Storage.pm 13653 2007-10-22 09:11:20Z gr $

use strict;
use warnings;
use Class::Null;


our $VERSION = '0.09';


use base qw(
    Class::Accessor::Complex
    Class::Accessor::Constructor
);


__PACKAGE__
    ->mk_constructor
    ->mk_boolean_accessors(qw(rollback_mode))
    ->mk_abstract_accessors(qw(create initialize_data))
    ->mk_scalar_accessors(qw(log));


use constant is_abstract => 1;


use constant DEFAULTS => (
    log => Class::Null->new,
);


sub setup {
    my $self = shift;
    $self->log->debug('creating storage schema');
    $self->create;
    $self->log->debug('populating storage with initial data');
    $self->initialize_data;
}


sub test_setup {}


# convenience method to access an object's id

sub id {
    my $self   = shift;
    my $object = shift;
    if ($@) {
        my $id = shift;
        $object->id($self, $id);
    } else {
        $object->id($self);
    }
}


# The storage object's signature is needed by Class::Scaffold::Storable to
# associate an object's id with the storage. We can't just store an id in a
# get_set_std accessor, because the business object's storage might be a
# multiplexing storage, and the object would have a different id in each
# multiplexed storage.

sub signature {
    my $self = shift;
    ref $self;
}


sub connect {}
sub disconnect {}

# Some storage classes won't make a difference between a normal connection and
# a lazy connection - for memory storages, there is no connection anyway. But
# see Data::Storage::DBI for a way to use lazy connections.

sub lazy_connect {}


1;


__END__



=head1 NAME

Data::Storage - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4

=item new

    my $obj = Data::Storage->new;
    my $obj = Data::Storage->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

=item clear_log

    $obj->clear_log;

Clears the value.

=item clear_rollback_mode

    $obj->clear_rollback_mode;

Clears the boolean value by setting it to 0.

=item log

    my $value = $obj->log;
    $obj->log($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item log_clear

    $obj->log_clear;

Clears the value.

=item rollback_mode

    $obj->rollback_mode($value);
    my $value = $obj->rollback_mode;

If called without an argument, returns the boolean value (0 or 1). If called
with an argument, it normalizes it to the boolean value. That is, the values
0, undef and the empty string become 0; everything else becomes 1.

=item rollback_mode_clear

    $obj->rollback_mode_clear;

Clears the boolean value by setting it to 0.

=item rollback_mode_set

    $obj->rollback_mode_set;

Sets the boolean value to 1.

=item set_rollback_mode

    $obj->set_rollback_mode;

Sets the boolean value to 1.

=back

Data::Storage inherits from L<Class::Accessor::Complex>,
L<Class::Accessor::Constructor>, and L<Class::Accessor::Constructor::Base>.

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

