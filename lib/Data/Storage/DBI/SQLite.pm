package Data::Storage::DBI::SQLite;
use strict;
use warnings;
our $VERSION = '0.11';
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
__END__



=head1 NAME

Data::Storage::DBI::SQLite - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage::DBI::SQLite->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4



=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see L<http://search.cpan.org/dist/Data-Storage/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2004-2009 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

