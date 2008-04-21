package Data::Storage::Mock;

# $Id: Mock.pm 13653 2007-10-22 09:11:20Z gr $

use strict;
use warnings;


our $VERSION = '0.06';


use base qw(Data::Storage Class::Accessor::Complex);


__PACKAGE__->mk_scalar_accessors(qw(should_die_on_connect));


sub connect {
    my $self = shift;
    $self->die_on_connect if $self->should_die_on_connect;
}


sub die_on_connect {
    my $self = shift;
    throw Error::Hierarchy::Internal::CustomMessage(custom_message =>
        "can't connect",
    );
}


sub disconnect {
    my $self = shift;
    return unless $self->is_connected;
    $self->rollback_mode ? $self->rollback : $self->commit;
}


sub is_connected { 1 }


sub rollback {}
sub commit   {}


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

