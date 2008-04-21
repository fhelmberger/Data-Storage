package Data::Storage::DBI::Mock;

# $Id: Mock.pm 10689 2006-02-02 15:59:23Z gr $

use strict;
use warnings;


our $VERSION = '0.05';


use base 'Data::Storage::Mock';


sub die_on_connect {
    my $self = shift;

    # simulate the bare minimum of a ::DBH exception

    throw Error::Hierarchy::Internal::DBI::DBH(
        error  => "can't connect",
        errstr => "can't connect",
        err    => 1,
    );
}


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

