package Data::Storage::DBI::SQLite;

# $Id: SQLite.pm 9190 2005-06-14 14:47:46Z gr $

use strict;
use warnings;


our $VERSION = '0.06';


use base 'Data::Storage::DBI';


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
        unlink $self->dbname or
            throw Error::Hierarchy::Internal::CustomMessage(custom_message =>
                sprintf "can't unlink %s: %s\n", $self->dbname, $!
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

