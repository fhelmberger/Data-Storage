package Data::Storage::DBI::Sybase;

# $Id: Sybase.pm 13653 2007-10-22 09:11:20Z gr $

use strict;
use warnings;


our $VERSION = '0.05';


use base qw(Data::Storage::DBI Class::Accessor::Complex);


__PACKAGE__->mk_scalar_accessors(qw(dbserver));


sub connect_string {
    my $self = shift;
    sprintf("DBI:Sybase:server=%s;database=%s", $self->dbserver, $self->dbname);
}


# no LongReadLen

sub get_connect_options {
    my $self = shift;
    { RaiseError  => $self->RaiseError,
      PrintError  => $self->PrintError,
      AutoCommit  => $self->AutoCommit,
      HandleError => $self->HandleError,
    }
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

{% p.write_inheritance %}

=head1 METHODS

=over 4

{% p.write_methods %}

=back

{% PROCESS standard_pod %}

=cut

