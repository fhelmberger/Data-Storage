package Data::Storage;

# $Id: Storage.pm 13653 2007-10-22 09:11:20Z gr $

use strict;
use warnings;
use Class::Null;


our $VERSION = '0.02';


use base 'Class::Accessor::Complex';


__PACKAGE__
    ->mk_new
    ->mk_boolean_accessors(qw(rollback_mode))
    ->mk_abstract_accessors(qw(create initialize_data))
    ->mk_scalar_accessors(qw(log));


use constant is_abstract => 1;


use constant DEFAULTS => (
    log => Class::Null->new,
);


sub setup {
    my $self = shift;
    $self->log->debug('creating storage schema');
    $self->create;
    $self->log->debug('populating storage with initial data');
    $self->initialize_data;
}


sub test_setup {}


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


sub connect {}
sub disconnect {}

# Some storage classes won't make a difference between a normal connection and
# a lazy connection - for memory storages, there is no connection anyway. But
# see Data::Storage::DBI for a way to use lazy connections.

sub lazy_connect {}


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

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

