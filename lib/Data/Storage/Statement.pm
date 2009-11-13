package Data::Storage::Statement;
use strict;
use warnings;
use Data::Miscellany 'value_of';
our $VERSION = '0.11';
use base qw(Class::Accessor::Complex Class::Accessor::Constructor);
#<<<
__PACKAGE__
    ->mk_constructor
    ->mk_scalar_accessors(qw(sth));
#>>>

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
__END__



=head1 NAME

Data::Storage::Statement - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage::Statement->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4

=item C<new>

    my $obj = Data::Storage::Statement->new;
    my $obj = Data::Storage::Statement->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

=item C<clear_sth>

    $obj->clear_sth;

Clears the value.

=item C<sth>

    my $value = $obj->sth;
    $obj->sth($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item C<sth_clear>

    $obj->sth_clear;

Clears the value.

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

