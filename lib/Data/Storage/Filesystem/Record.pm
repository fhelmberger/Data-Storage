package Data::Storage::Filesystem::Record;

use strict;
use warnings;


our $VERSION = '0.08';


use base 'Class::Accessor::Complex';


__PACKAGE__
    ->mk_new
    ->mk_boolean_accessors(qw(stored))
    ->mk_scalar_accessors(qw(filename data mode));


1;


__END__



=head1 NAME

Data::Storage::Filesystem::Record - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage::Filesystem::Record->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4

=item new

    my $obj = Data::Storage::Filesystem::Record->new;
    my $obj = Data::Storage::Filesystem::Record->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

=item clear_data

    $obj->clear_data;

Clears the value.

=item clear_filename

    $obj->clear_filename;

Clears the value.

=item clear_mode

    $obj->clear_mode;

Clears the value.

=item clear_stored

    $obj->clear_stored;

Clears the boolean value by setting it to 0.

=item data

    my $value = $obj->data;
    $obj->data($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item data_clear

    $obj->data_clear;

Clears the value.

=item filename

    my $value = $obj->filename;
    $obj->filename($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item filename_clear

    $obj->filename_clear;

Clears the value.

=item mode

    my $value = $obj->mode;
    $obj->mode($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item mode_clear

    $obj->mode_clear;

Clears the value.

=item set_stored

    $obj->set_stored;

Sets the boolean value to 1.

=item stored

    $obj->stored($value);
    my $value = $obj->stored;

If called without an argument, returns the boolean value (0 or 1). If called
with an argument, it normalizes it to the boolean value. That is, the values
0, undef and the empty string become 0; everything else becomes 1.

=item stored_clear

    $obj->stored_clear;

Clears the boolean value by setting it to 0.

=item stored_set

    $obj->stored_set;

Sets the boolean value to 1.

=back

Data::Storage::Filesystem::Record inherits from
L<Class::Accessor::Complex>.

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

