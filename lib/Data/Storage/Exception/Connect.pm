use 5.008;
use strict;
use warnings;

package Data::Storage::Exception::Connect;
# ABSTRACT: Exception raised on a connection failure
use parent qw(Data::Storage::Exception);
__PACKAGE__->mk_scalar_accessors(qw(dbname dbuser reason));
use constant default_message =>
  'Cannot connect to storage [%s] as user [%s]: %s';
use constant PROPERTIES => (qw/dbname dbuser reason/);
1;

