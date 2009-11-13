package Data::Storage::Null;
use strict;
use warnings;
use Class::Null;
our $VERSION = '0.11';

# use Class::Null for methods not implemented here or in
# Data::Storage
use base 'Data::Storage::Memory';
sub FIRST_CONSTRUCTOR_ARGS { () }
sub is_connected           { 1 }
sub AUTOLOAD               { Class::Null->new }
1;
__END__



=head1 NAME

Data::Storage::Null - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage::Null->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4



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

