package Data::Storage::DBI::Sybase;

# $Id: Sybase.pm 13653 2007-10-22 09:11:20Z gr $

use strict;
use warnings;


our $VERSION = '0.01';


use base qw(Data::Storage::DBI Class::Accessor::Complex);


__PACKAGE__->mk_scalar_accessors(qw(dbserver));


sub connect_string {
    my $self = shift;
    sprintf("DBI:Sybase:server=%s;database=%s", $self->dbserver, $self->dbname);
}


# no LongReadLen

sub get_connect_options {
    my $self = shift;
    { RaiseError  => $self->RaiseError,
      PrintError  => $self->PrintError,
      AutoCommit  => $self->AutoCommit,
      HandleError => $self->HandleError,
    }
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

