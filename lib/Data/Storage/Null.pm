use 5.008;
use strict;
use warnings;

package Data::Storage::Null;
# ABSTRACT: Base class for null storages
use Class::Null;

# use Class::Null for methods not implemented here or in
# Data::Storage
use parent 'Data::Storage::Memory';
sub FIRST_CONSTRUCTOR_ARGS { () }
sub is_connected           { 1 }
sub AUTOLOAD               { Class::Null->new }
1;

=method FIRST_CONSTRUCTOR_ARGS

FIXME

=method is_connected

FIXME

