package Data::Storage;
use 5.006;
use strict;
use warnings;
use Class::Null;
our $VERSION = '0.11';
use base qw(
  Class::Accessor::Complex
  Class::Accessor::Constructor
);
#<<<
__PACKAGE__
    ->mk_constructor
    ->mk_boolean_accessors(qw(rollback_mode))
    ->mk_abstract_accessors(qw(create initialize_data))
    ->mk_scalar_accessors(qw(log));
#>>>
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
__END__

=head1 NAME

Data::Storage - Generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4

=item C<new>

    my $obj = Data::Storage->new;
    my $obj = Data::Storage->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

=item C<clear_log>

    $obj->clear_log;

Clears the value.

=item C<clear_rollback_mode>

    $obj->clear_rollback_mode;

Clears the boolean value by setting it to 0.

=item C<log>

    my $value = $obj->log;
    $obj->log($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item C<log_clear>

    $obj->log_clear;

Clears the value.

=item C<rollback_mode>

    $obj->rollback_mode($value);
    my $value = $obj->rollback_mode;

If called without an argument, returns the boolean value (0 or 1). If called
with an argument, it normalizes it to the boolean value. That is, the values
0, undef and the empty string become 0; everything else becomes 1.

=item C<rollback_mode_clear>

    $obj->rollback_mode_clear;

Clears the boolean value by setting it to 0.

=item C<rollback_mode_set>

    $obj->rollback_mode_set;

Sets the boolean value to 1.

=item C<set_rollback_mode>

    $obj->set_rollback_mode;

Sets the boolean value to 1.

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
