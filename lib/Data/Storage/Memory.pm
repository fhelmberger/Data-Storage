use 5.008;
use strict;
use warnings;

package Data::Storage::Memory;
# ABSTRACT: Base class for memory-based storages
use parent 'Data::Storage';
sub connect { }

sub disconnect {
    my $self = shift;
    return unless $self->is_connected;
    $self->rollback_mode ? $self->rollback : $self->commit;
}
sub is_connected { 1 }

# might implement this later using transactional hashes or some such
sub rollback { }
sub commit   { }
1;

=method commit

FIXME

=method connect

FIXME

=method disconnect

FIXME

=method is_connected

FIXME

=method rollback

FIXME

