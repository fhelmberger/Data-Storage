package Data::Storage::DBI::Unrealized;

# $Id$

use strict;
use warnings;


our $VERSION = '0.07';


use base 'Class::Accessor::Complex';


__PACKAGE__
    ->mk_new
    ->mk_scalar_accessors(qw(callback));


use constant DEFAULTS => ();
use constant FIRST_CONSTRUCTOR_ARGS => ();


sub AUTOLOAD {
    my $self = shift;
    (my $method = our $AUTOLOAD) =~ s/.*://;
    $self->callback->connect;
    $self->callback->dbh->$method(@_);
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

