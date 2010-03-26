use 5.008;
use strict;
use warnings;

package Data::Storage::DBI::Mock;
# ABSTRACT: Base class for mock DBI storages
use parent 'Data::Storage::Mock';

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

=method die_on_connect

FIXME

