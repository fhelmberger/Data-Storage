package Data::Storage::DBI::Oracle;

# $Id: Oracle.pm 13295 2007-07-02 11:38:45Z gr $

use strict;
use warnings;


our $VERSION = '0.06';


use base 'Data::Storage::DBI';


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


__END__

{% USE p = PodGenerated %}

=head1 NAME

{% p.package %} - generic abstract storage mechanism

=head1 SYNOPSIS

    {% p.package %}->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4

{% p.write_methods %}

=back

{% p.write_inheritance %}

{% PROCESS standard_pod %}

=cut

