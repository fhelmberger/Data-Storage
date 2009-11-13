package Data::Storage::DBI::Unrealized;
use strict;
use warnings;
our $VERSION = '0.11';
use base 'Class::Accessor::Complex';
#<<<
__PACKAGE__
    ->mk_new
    ->mk_scalar_accessors(qw(callback));
#>>>
use constant DEFAULTS               => ();
use constant FIRST_CONSTRUCTOR_ARGS => ();

sub AUTOLOAD {
    my $self = shift;
    (my $method = our $AUTOLOAD) =~ s/.*://;
    $self->callback->connect;
    $self->callback->dbh->$method(@_);
}
1;
__END__



=head1 NAME

Data::Storage::DBI::Unrealized - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage::DBI::Unrealized->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4

=item C<new>

    my $obj = Data::Storage::DBI::Unrealized->new;
    my $obj = Data::Storage::DBI::Unrealized->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

=item C<callback>

    my $value = $obj->callback;
    $obj->callback($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item C<callback_clear>

    $obj->callback_clear;

Clears the value.

=item C<clear_callback>

    $obj->clear_callback;

Clears the value.

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see L<http://search.cpan.org/dist/Data-Storage/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2004-2009 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

