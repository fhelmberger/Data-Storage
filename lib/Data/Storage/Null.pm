package Data::Storage::Null;

# $Id: Null.pm 9190 2005-06-14 14:47:46Z gr $

use strict;
use warnings;
use Class::Null;


our $VERSION = '0.06';


# use Class::Null for methods not implemented here or in
# Data::Storage

use base 'Data::Storage::Memory';

sub is_connected { 1 }

sub AUTOLOAD { Class::Null->new }


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

=head1 METHODS

=over 4

{% p.write_methods %}

=back

{% p.write_inheritance %}

{% PROCESS standard_pod %}

=cut

