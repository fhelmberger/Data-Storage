use 5.008;
use strict;
use warnings;

package Data::Storage::Exception;
# ABSTRACT: Base class for storage exceptions
use parent qw(Error::Hierarchy Class::Accessor::Complex);
1;

