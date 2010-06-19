use 5.008;
use strict;
use warnings;

package Data::Storage::DBI::Postgres;

# ABSTRACT: Base class for PostgreSQL DBI storages
use Error::Hierarchy::Util 'assert_defined';
use parent qw(Data::Storage::DBI Class::Accessor::Complex);
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
    $self->dbh->last_insert_id(undef, undef, undef, undef,
        { sequence => $sequence_name });
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

=begin :prelude

=for stopwords PostgreSQL

=end :prelude

=method connect

FIXME

=method last_id

FIXME

=method next_id

FIXME

=method rewrite_query_for_dbd

FIXME

=method test_setup

FIXME

=method trace

FIXME

