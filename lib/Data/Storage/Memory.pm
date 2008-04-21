package Data::Storage::Memory;

# $Id: Memory.pm 9190 2005-06-14 14:47:46Z gr $

use strict;
use warnings;


our $VERSION = '0.05';


use base 'Data::Storage';


sub connect {}


sub disconnect {
    my $self = shift;
    return unless $self->is_connected;
    $self->rollback_mode ? $self->rollback : $self->commit;
}


sub is_connected { 1 }


# might implement this later using transactional hashes or some such

sub rollback {}
sub commit   {}


1;


__END__

{% USE p = PodGenerated %}

=head1 NAME

{% p.package %} - generic abstract storage mechanism

=head1 SYNOPSIS

    {% p.package %}->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

{% p.write_inheritance %}

=head1 METHODS

=over 4

{% p.write_methods %}

=back

{% PROCESS standard_pod %}

=cut

