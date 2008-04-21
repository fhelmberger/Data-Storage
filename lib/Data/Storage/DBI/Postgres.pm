package Data::Storage::DBI::Postgres;

# $Id$

use strict;
use warnings;
use Error::Hierarchy::Util 'assert_defined';


our $VERSION = '0.01';


use base qw(Data::Storage::DBI Class::Accessor::Complex);


__PACKAGE__->mk_scalar_accessors(qw(dbhost));


sub connect_string {
    my $self = shift;
    if ($self->dbhost) {
        sprintf("dbi:Pg:dbname=%s;host=%s", $self->dbname, $self->dbhost)
    } else {
        sprintf("dbi:Pg:dbname=%s", $self->dbname);
    }
}


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

=head1 NAME

Data::Storage - generic abstract storage mechanism

=head1 SYNOPSIS

None yet (see below).

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<datastorage> tag.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-data-storage@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

Heinz Ekker C<< ek@univie.ac.at >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

