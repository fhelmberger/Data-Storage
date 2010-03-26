use 5.008;
use strict;
use warnings;

package Data::Storage::Statement;
# ABSTRACT: Wrapper for DBI statements
use Data::Miscellany 'value_of';
use parent qw(Class::Accessor::Complex Class::Accessor::Constructor);
__PACKAGE__
    ->mk_constructor
    ->mk_scalar_accessors(qw(sth));

# Define functions and class methods lest they be handled by AUTOLOAD, because
# there's no $self->sth to forward anything on in those cases.
sub DEFAULTS               { () }
sub FIRST_CONSTRUCTOR_ARGS { () }
sub DESTROY                { }

# Most methods are forwarded onto the statement handle, except for the ones
# handled differently below.
sub AUTOLOAD {
    (my $method = our $AUTOLOAD) =~ s/.*://;
    no strict 'refs';
    *$AUTOLOAD = sub {
        my $self = shift;

        # This package is just a wrapper, so report where the call came from
        local $Error::Depth = $Error::Depth + 1;
        $self->sth->$method(@_);
    };
    goto &$AUTOLOAD;
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
    my $result = ${ $args[1] };
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

=method DEFAULTS

FIXME

=method FIRST_CONSTRUCTOR_ARGS

FIXME

=method Statement

FIXME

=method bind_param

FIXME

=method bind_param_inout

FIXME

