package Data::Storage::DBI::Postgres;

# $Id$

use strict;
use warnings;
use Error::Hierarchy::Util 'assert_defined';


our $VERSION = '0.05';


use base qw(Data::Storage::DBI Class::Accessor::Complex);


use constant connect_string_dbi_id => 'Pg';


sub connect {
    my $self = shift;

    $self->SUPER::connect(@_);
    # FIXME: is this the right place and the right way for setting utf-8 encoding?
    $self->dbh->{pg_enable_utf8} = 1;
}


sub test_setup {
    my $self = shift;
    $self->connect;
    $self->disconnect;
}


sub last_id {
    my ($self, $sequence_name) = @_;
    $self->dbh->last_insert_id(undef,undef,undef,undef,
			       {sequence => $sequence_name});
}


sub next_id {
    my ($self, $sequence_name) = @_;

    unless ($sequence_name) {
	throw Error::Hierarchy::Internal::ValueUndefined;
    }

    my $sth = $self->prepare("
	SELECT NEXTVAL('$sequence_name')");
    $sth->execute;
    my ($next_id) = $sth->fetchrow_array;
    $sth->finish;
    $next_id;
}


sub trace {
    my $self = shift;
    $self->dbh->trace(@_);
}


# Database type-specifc rewrites

sub rewrite_query_for_dbd {
    my ($self, $query) = @_;

    $query =~ s/<USER>/CURRENT_USER/g;
    $query =~ s/<NOW>/NOW()/g;
    $query =~ s/<NEXTVAL>\((.*?)\)/NEXTVAL('$1')/g;
    $query =~ s/<BOOL>\((.*?)\)/expression::bool($1)/g;

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

{% p.write_inheritance %}

=head1 METHODS

=over 4

{% p.write_methods %}

=back

{% PROCESS standard_pod %}

=cut

