package Data::Storage::DBI::Oracle;

# $Id: Oracle.pm 13295 2007-07-02 11:38:45Z gr $

use strict;
use warnings;


our $VERSION = '0.03';


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

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

