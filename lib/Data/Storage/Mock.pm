package Data::Storage::Mock;
use strict;
use warnings;
our $VERSION = '0.11';
use base qw(Data::Storage Class::Accessor::Complex);
__PACKAGE__->mk_scalar_accessors(qw(should_die_on_connect));

sub connect {
    my $self = shift;
    $self->die_on_connect if $self->should_die_on_connect;
}

sub die_on_connect {
    my $self = shift;
    throw Error::Hierarchy::Internal::CustomMessage(
        custom_message => "can't connect",);
}

sub disconnect {
    my $self = shift;
    return unless $self->is_connected;
    $self->rollback_mode ? $self->rollback : $self->commit;
}
sub is_connected { 1 }
sub rollback     { }
sub commit       { }
1;
__END__



=head1 NAME

Data::Storage::Mock - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage::Mock->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4

=item C<clear_should_die_on_connect>

    $obj->clear_should_die_on_connect;

Clears the value.

=item C<should_die_on_connect>

    my $value = $obj->should_die_on_connect;
    $obj->should_die_on_connect($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item C<should_die_on_connect_clear>

    $obj->should_die_on_connect_clear;

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

