use 5.008;
use strict;
use warnings;

package Data::Storage::DBI::Unrealized;
# ABSTRACT: Proxy class for lazy DBI connections
use parent 'Class::Accessor::Complex';
__PACKAGE__
    ->mk_new
    ->mk_scalar_accessors(qw(callback));
use constant DEFAULTS               => ();
use constant FIRST_CONSTRUCTOR_ARGS => ();

sub AUTOLOAD {
    my $self = shift;
    (my $method = our $AUTOLOAD) =~ s/.*://;
    $self->callback->connect;
    $self->callback->dbh->$method(@_);
}
1;

