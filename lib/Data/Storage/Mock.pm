use 5.008;
use strict;
use warnings;

package Data::Storage::Mock;
# ABSTRACT: Base class for mock storages
use parent qw(Data::Storage Class::Accessor::Complex);
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

=method commit

FIXME

=method connect

FIXME

=method die_on_connect

FIXME

=method disconnect

FIXME

=method is_connected

FIXME

=method rollback

FIXME

