package Data::Storage::DBI::Result;

# $Id: Result.pm 13653 2007-10-22 09:11:20Z gr $

use strict;
use warnings;
use DBI ':sql_types';
use Error::Hierarchy::Util 'assert_defined';


our $VERSION = '0.08';


use base 'Class::Accessor::Complex';


__PACKAGE__
    ->mk_new
    ->mk_scalar_accessors(qw(sth result));


sub fetch {
    my $self = shift;

    assert_defined $self->sth, 'called without set statement handle.';

    $self->sth->fetch;
}


sub finish {
    my $self = shift;

    assert_defined $self->sth, 'called without set statement handle.';

    $self->sth->finish;
}


sub rows {
    my $self = shift;

    assert_defined $self->sth, 'called without set statement handle.';

    $self->sth->rows;
}


1;


__END__



=head1 NAME

Data::Storage::DBI::Result - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage::DBI::Result->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4

=item new

    my $obj = Data::Storage::DBI::Result->new;
    my $obj = Data::Storage::DBI::Result->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

=item clear_result

    $obj->clear_result;

Clears the value.

=item clear_sth

    $obj->clear_sth;

Clears the value.

=item result

    my $value = $obj->result;
    $obj->result($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item result_clear

    $obj->result_clear;

Clears the value.

=item sth

    my $value = $obj->sth;
    $obj->sth($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item sth_clear

    $obj->sth_clear;

Clears the value.

=back

Data::Storage::DBI::Result inherits from L<Class::Accessor::Complex>.

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

