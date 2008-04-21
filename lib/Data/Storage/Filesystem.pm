package Data::Storage::Filesystem;

# $Id: Filesystem.pm 13653 2007-10-22 09:11:20Z gr $

use strict;
use warnings;


our $VERSION = '0.06';


use base qw(Data::Storage Class::Accessor::Complex);


use constant DEFAULTS => (
    mode => '0664'
);


__PACKAGE__
    ->mk_hash_accessors(qw(trans_cache))
    ->mk_scalar_accessors(qw(fspath mode));


sub connect {
    my $self = shift;
    die sprintf "invalid target directory: '%s'",
        $self->fspath || ''
    unless defined $self->fspath
       && -d $self->fspath && -w _;
}

# we will keep this very simple and naive for now,
# just fulfilling our current, very limited needs.
# hence: no fooling around, i.e. changing the base
# directory while operating etc.

sub cache_put {
    my ($self, $key, $rec) = @_;
    $self->trans_cache->{$key} =
           ref $rec ? $rec : [$rec];
}

sub cache_get {
    my ($self, $key) = @_;
    my $rec = exists $self->trans_cache->{$key}
                   ? $self->trans_cache->{$key}
                   : [];
    wantarray ? @$rec : $rec->[0];
}

sub cache_rmv {
    my ($self, $key) = @_;
    delete $self->trans_cache->{$key};
}

sub cache_lst {
    map { @$_ } shift->trans_cache_values;
}

sub rollback {
    shift->trans_cache_clear
}

sub commit {
    my $self = shift;

    return 1 unless scalar $self->trans_cache_keys;

    my $failed;
    for my $rec ($self->cache_lst) {
        my $handle;
        open ($handle, sprintf ">%s",$rec->filename) || do {
            ++$failed;
            last;
        };
        print $handle $rec->data;
        close($handle) || do {
            ++$failed;
            last;
        };
        chmod $rec->mode, $rec->filename;
        $rec->stored(1);
    }
    if ($failed) {
        unlink $_->filename
           for (grep {$_->stored} $self->cache_lst);
        $self->rollback;
        return 0;
    }
    $self->rollback;
    1;
}


sub signature {
    my $self = shift;
    sprintf "%s,fspath=%s", $self->SUPER::signature(), $self->fspath;
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

