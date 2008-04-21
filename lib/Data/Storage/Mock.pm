package Data::Storage::Mock;

# $Id: Mock.pm 13653 2007-10-22 09:11:20Z gr $

use strict;
use warnings;


our $VERSION = '0.01';


use base qw(Data::Storage Class::Accessor::Complex);


__PACKAGE__->mk_scalar_accessors(qw(should_die_on_connect));


sub connect {
    my $self = shift;
    $self->die_on_connect if $self->should_die_on_connect;
}


sub die_on_connect {
    my $self = shift;
    throw Error::Hierarchy::Internal::CustomMessage(custom_message =>
        "can't connect",
    );
}


sub disconnect {
    my $self = shift;
    return unless $self->is_connected;
    $self->rollback_mode ? $self->rollback : $self->commit;
}


sub is_connected { 1 }


sub rollback {}
sub commit   {}


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

