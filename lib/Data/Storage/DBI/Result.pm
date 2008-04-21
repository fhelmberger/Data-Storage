package Data::Storage::DBI::Result;

# $Id: Result.pm 13653 2007-10-22 09:11:20Z gr $

use strict;
use warnings;
use DBI ':sql_types';
use Error::Hierarchy::Util 'assert_defined';


our $VERSION = '0.05';


use base 'Class::Accessor::Complex';


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

