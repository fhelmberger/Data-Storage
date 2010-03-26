use 5.008;
use strict;
use warnings;

package Data::Storage::Filesystem::Record;
# ABSTRACT: A record from a filesystem-based storage
use parent 'Class::Accessor::Complex';
__PACKAGE__
    ->mk_new
    ->mk_boolean_accessors(qw(stored))
    ->mk_scalar_accessors(qw(filename data mode));
1;

