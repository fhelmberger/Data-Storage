use 5.008;
use strict;
use warnings;

package Data::Storage::DBI::SQLite;
# ABSTRACT: Base class for SQLite DBI storages
use parent 'Data::Storage::DBI';

sub connect_string {
    my $self = shift;
    sprintf("dbi:SQLite:dbname=%s", $self->dbname);
}

# Prepare a test database; unlink the existing database and recreate it with
# the initial data. This method is called at the beginning of test programs.
# The functionality implemented here is specific to SQLite, as that's probably
# only going to be used for tests. If you're testing against Oracle databases
# where setup is going to take a lot more steps than unlinking and recreating,
# you might want to prepare a test database beforehand and leave this method
# empty, so the same database is reused for many tests.
sub test_setup {
    my $self = shift;
    if (-e $self->dbname) {
        unlink $self->dbname
          or throw Error::Hierarchy::Internal::CustomMessage(
            custom_message => sprintf "can't unlink %s: %s\n",
            $self->dbname, $!
          );
    }
    $self->connect;
    $self->setup;
}

sub last_id {
    my $self = shift;
    $self->dbh->func('last_insert_rowid');
}
1;

=begin :prelude

=for stopwords SQLite

=end :prelude

=method connect_string

FIXME

=method last_id

FIXME

=method test_setup

FIXME

