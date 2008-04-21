package Data::Storage::Filesystem::Record;

use strict;
use warnings;


our $VERSION = '0.05';


use base 'Class::Accessor::Complex';


__PACKAGE__
    ->mk_new
    ->mk_boolean_accessors(qw(stored))
    ->mk_scalar_accessors(qw(filename data mode));


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

