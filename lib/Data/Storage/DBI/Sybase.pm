package Data::Storage::DBI::Sybase;
use strict;
use warnings;
our $VERSION = '0.11';
use base qw(Data::Storage::DBI Class::Accessor::Complex);
__PACKAGE__->mk_scalar_accessors(qw(dbserver));

sub connect_string {
    my $self = shift;
    sprintf("DBI:Sybase:server=%s;database=%s", $self->dbserver, $self->dbname);
}

# no LongReadLen
sub get_connect_options {
    my $self = shift;
    {   RaiseError  => $self->RaiseError,
        PrintError  => $self->PrintError,
        AutoCommit  => $self->AutoCommit,
        HandleError => $self->HandleError,
    };
}
1;
__END__



=head1 NAME

Data::Storage::DBI::Sybase - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage::DBI::Sybase->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4

=item C<clear_dbserver>

    $obj->clear_dbserver;

Clears the value.

=item C<dbserver>

    my $value = $obj->dbserver;
    $obj->dbserver($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item C<dbserver_clear>

    $obj->dbserver_clear;

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

