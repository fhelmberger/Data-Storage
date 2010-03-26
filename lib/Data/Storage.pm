use 5.008;
use strict;
use warnings;

package Data::Storage;
# ABSTRACT: Base class for storages
use Class::Null;
use parent qw(
  Class::Accessor::Complex
  Class::Accessor::Constructor
);
__PACKAGE__
    ->mk_constructor
    ->mk_boolean_accessors(qw(rollback_mode))
    ->mk_abstract_accessors(qw(create initialize_data))
    ->mk_scalar_accessors(qw(log));
use constant is_abstract => 1;
use constant DEFAULTS => (log => Class::Null->new,);

sub setup {
    my $self = shift;
    $self->log->debug('creating storage schema');
    $self->create;
    $self->log->debug('populating storage with initial data');
    $self->initialize_data;
}
sub test_setup { }

# convenience method to access an object's id
sub id {
    my $self   = shift;
    my $object = shift;
    if ($@) {
        my $id = shift;
        $object->id($self, $id);
    } else {
        $object->id($self);
    }
}

# The storage object's signature is needed by Class::Scaffold::Storable to
# associate an object's id with the storage. We can't just store an id in a
# get_set_std accessor, because the business object's storage might be a
# multiplexing storage, and the object would have a different id in each
# multiplexed storage.
sub signature {
    my $self = shift;
    ref $self;
}
sub connect    { }
sub disconnect { }

# Some storage classes won't make a difference between a normal connection and
# a lazy connection - for memory storages, there is no connection anyway. But
# see Data::Storage::DBI for a way to use lazy connections.
sub lazy_connect { }
1;

=method connect

FIXME

=method disconnect

FIXME

=method id

FIXME

=method lazy_connect

FIXME

=method setup

FIXME

=method signature

FIXME

=method test_setup

FIXME

