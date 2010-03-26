use 5.008;
use strict;
use warnings;

package Data::Storage::DBI::Result;
# ABSTRACT: Base class for DBI query results
use DBI ':sql_types';
use Error::Hierarchy::Util 'assert_defined';
use parent 'Class::Accessor::Complex';
__PACKAGE__
    ->mk_new
    ->mk_scalar_accessors(qw(sth result));

sub fetch {
    my $self = shift;
    assert_defined $self->sth, 'called without set statement handle.';
    $self->sth->fetch;
}

sub finish {
    my $self = shift;
    assert_defined $self->sth, 'called without set statement handle.';
    $self->sth->finish;
}

sub rows {
    my $self = shift;
    assert_defined $self->sth, 'called without set statement handle.';
    $self->sth->rows;
}
1;

=method fetch

FIXME

=method finish

FIXME

=method rows

FIXME

