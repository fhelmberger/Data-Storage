package Data::Storage::Statement;

# $Id: Statement.pm 13653 2007-10-22 09:11:20Z gr $

use strict;
use warnings;
use Data::Miscellany 'value_of';


our $VERSION = '0.06';


use base qw(Class::Accessor::Complex Class::Accessor::Constructor);


__PACKAGE__
    ->mk_constructor
    ->mk_scalar_accessors(qw(sth));


# Define functions and class methods lest they be handled by AUTOLOAD, because
# there's no $self->sth to forward anything on in those cases.

sub DEFAULTS { () }
sub FIRST_CONSTRUCTOR_ARGS { () }
sub DESTROY {}

# Most methods are forwarded onto the statement handle, except for the ones
# handled differently below.

sub AUTOLOAD {
    my $self = shift;
    (my $method = our $AUTOLOAD) =~ s/.*://;

    # This package is just a wrapper, so report where the call came from
    local $Error::Depth = $Error::Depth + 1;

    $self->sth->$method(@_);
}


# Stringify potential value objects.

sub bind_param {
    my ($self, @args) = @_;
    $args[1] = value_of $args[1];

    # This package is just a wrapper, so report where the call came from
    local $Error::Depth = $Error::Depth + 1;

    $self->sth->bind_param(@args);
}


# If we are given a value object, redirect the binding to the value object's
# internal value directly.

sub bind_param_inout {
    my ($self, @args) = @_;
    my $result = ${$args[1]};
    if (ref $result && UNIVERSAL::isa($result, 'Class::Value')) {
        $result->{_value} = undef unless exists $result->{_value};
        $args[1] = \$result->{_value};
    }

    # This package is just a wrapper, so report where the call came from
    local $Error::Depth = $Error::Depth + 1;

    $self->sth->bind_param_inout(@args);
}


sub Statement {
    my $self = shift;
    return $self->sth->{Statement} unless @_;
    $self->sth->{Statement} = $_[0];
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

