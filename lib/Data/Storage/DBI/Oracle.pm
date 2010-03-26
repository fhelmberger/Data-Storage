use 5.008;
use strict;
use warnings;

package Data::Storage::DBI::Oracle;
# ABSTRACT: Base class for Oracle DBI storages
use parent 'Data::Storage::DBI';

sub connect_string {
    my $self = shift;
    sprintf("dbi:Oracle:%s", $self->dbname);
}

# Database type-specifc rewrites
sub rewrite_query_for_dbd {
    my ($self, $query) = @_;
    $query =~ s/<USER>/user/g;
    $query =~ s/<NOW>/sysdate/g;
    $query =~ s/<NEXTVAL>\((.*?)\)/$1.NEXTVAL/g;
    $query =~ s/<BOOL>\((.*?)\)/sprintf "DECODE(%s, '%s', 1, '%s', 0)", $1,
        $self->delegate->YES, $self->delegate->NO
    /eg;
    $query;
}
1;

=method connect_string

FIXME

=method rewrite_query_for_dbd

FIXME

