package Data::Storage::Filesystem;
use strict;
use warnings;
our $VERSION = '0.10';
use base qw(Data::Storage Class::Accessor::Complex);
use constant DEFAULTS => (mode => '0664');
#<<<
__PACKAGE__
    ->mk_hash_accessors(qw(trans_cache))
    ->mk_scalar_accessors(qw(fspath mode));
#>>>

sub connect {
    my $self = shift;
    die sprintf "invalid target directory: '%s'", $self->fspath
      || ''
      unless defined $self->fspath && -d $self->fspath && -w _;
}

# we will keep this very simple and naive for now,
# just fulfilling our current, very limited needs.
# hence: no fooling around, i.e. changing the base
# directory while operating etc.
sub cache_put {
    my ($self, $key, $rec) = @_;
    $self->trans_cache->{$key} = ref $rec ? $rec : [$rec];
}

sub cache_get {
    my ($self, $key) = @_;
    my $rec =
      exists $self->trans_cache->{$key}
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
    shift->trans_cache_clear;
}

sub commit {
    my $self = shift;
    return 1 unless scalar $self->trans_cache_keys;
    my $failed;
    for my $rec ($self->cache_lst) {
        my $handle;
        open($handle, sprintf ">%s", $rec->filename) || do {
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
        unlink $_->filename for (grep { $_->stored } $self->cache_lst);
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



=head1 NAME

Data::Storage::Filesystem - generic abstract storage mechanism

=head1 SYNOPSIS

    Data::Storage::Filesystem->new;

=head1 DESCRIPTION

None yet. This is an early release; fully functional, but undocumented. The
next release will have more documentation.

=head1 METHODS

=over 4

=item C<clear_fspath>

    $obj->clear_fspath;

Clears the value.

=item C<clear_mode>

    $obj->clear_mode;

Clears the value.

=item C<clear_trans_cache>

    $obj->clear_trans_cache;

Deletes all keys and values from the hash.

=item C<delete_trans_cache>

    $obj->delete_trans_cache(@keys);

Takes a list of keys and deletes those keys from the hash.

=item C<exists_trans_cache>

    if ($obj->exists_trans_cache($key)) { ... }

Takes a key and returns a true value if the key exists in the hash, and a
false value otherwise.

=item C<fspath>

    my $value = $obj->fspath;
    $obj->fspath($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item C<fspath_clear>

    $obj->fspath_clear;

Clears the value.

=item C<keys_trans_cache>

    my @keys = $obj->keys_trans_cache;

Returns a list of all hash keys in no particular order.

=item C<mode>

    my $value = $obj->mode;
    $obj->mode($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item C<mode_clear>

    $obj->mode_clear;

Clears the value.

=item C<trans_cache>

    my %hash     = $obj->trans_cache;
    my $hash_ref = $obj->trans_cache;
    my $value    = $obj->trans_cache($key);
    my @values   = $obj->trans_cache([ qw(foo bar) ]);
    $obj->trans_cache(%other_hash);
    $obj->trans_cache(foo => 23, bar => 42);

Get or set the hash values. If called without arguments, it returns the hash
in list context, or a reference to the hash in scalar context. If called
with a list of key/value pairs, it sets each key to its corresponding value,
then returns the hash as described before.

If called with exactly one key, it returns the corresponding value.

If called with exactly one array reference, it returns an array whose elements
are the values corresponding to the keys in the argument array, in the same
order. The resulting list is returned as an array in list context, or a
reference to the array in scalar context.

If called with exactly one hash reference, it updates the hash with the given
key/value pairs, then returns the hash in list context, or a reference to the
hash in scalar context.

=item C<trans_cache_clear>

    $obj->trans_cache_clear;

Deletes all keys and values from the hash.

=item C<trans_cache_delete>

    $obj->trans_cache_delete(@keys);

Takes a list of keys and deletes those keys from the hash.

=item C<trans_cache_exists>

    if ($obj->trans_cache_exists($key)) { ... }

Takes a key and returns a true value if the key exists in the hash, and a
false value otherwise.

=item C<trans_cache_keys>

    my @keys = $obj->trans_cache_keys;

Returns a list of all hash keys in no particular order.

=item C<trans_cache_values>

    my @values = $obj->trans_cache_values;

Returns a list of all hash values in no particular order.

=item C<values_trans_cache>

    my @values = $obj->values_trans_cache;

Returns a list of all hash values in no particular order.

=back

Data::Storage::Filesystem inherits from L<Data::Storage>.

The superclass L<Data::Storage> defines these methods and functions:

    new(), clear_log(), clear_rollback_mode(), create(), disconnect(),
    id(), initialize_data(), lazy_connect(), log(), log_clear(),
    rollback_mode(), rollback_mode_clear(), rollback_mode_set(),
    set_rollback_mode(), setup(), test_setup()

The superclass L<Class::Accessor::Complex> defines these methods and
functions:

    mk_abstract_accessors(), mk_array_accessors(), mk_boolean_accessors(),
    mk_class_array_accessors(), mk_class_hash_accessors(),
    mk_class_scalar_accessors(), mk_concat_accessors(),
    mk_forward_accessors(), mk_hash_accessors(), mk_integer_accessors(),
    mk_new(), mk_object_accessors(), mk_scalar_accessors(),
    mk_set_accessors(), mk_singleton()

The superclass L<Class::Accessor> defines these methods and functions:

    _carp(), _croak(), _mk_accessors(), accessor_name_for(),
    best_practice_accessor_name_for(), best_practice_mutator_name_for(),
    follow_best_practice(), get(), make_accessor(), make_ro_accessor(),
    make_wo_accessor(), mk_accessors(), mk_ro_accessors(),
    mk_wo_accessors(), mutator_name_for(), set()

The superclass L<Class::Accessor::Installer> defines these methods and
functions:

    install_accessor()

The superclass L<Class::Accessor::Constructor> defines these methods and
functions:

    _make_constructor(), mk_constructor(), mk_constructor_with_dirty(),
    mk_singleton_constructor()

The superclass L<Data::Inherited> defines these methods and functions:

    every_hash(), every_list(), flush_every_cache_by_key()

The superclass L<Class::Accessor::Constructor::Base> defines these methods
and functions:

    STORE(), clear_dirty(), clear_hygienic(), clear_unhygienic(),
    contains_hygienic(), contains_unhygienic(), delete_hygienic(),
    delete_unhygienic(), dirty(), dirty_clear(), dirty_set(),
    elements_hygienic(), elements_unhygienic(), hygienic(),
    hygienic_clear(), hygienic_contains(), hygienic_delete(),
    hygienic_elements(), hygienic_insert(), hygienic_is_empty(),
    hygienic_size(), insert_hygienic(), insert_unhygienic(),
    is_empty_hygienic(), is_empty_unhygienic(), set_dirty(),
    size_hygienic(), size_unhygienic(), unhygienic(), unhygienic_clear(),
    unhygienic_contains(), unhygienic_delete(), unhygienic_elements(),
    unhygienic_insert(), unhygienic_is_empty(), unhygienic_size()

The superclass L<Tie::StdHash> defines these methods and functions:

    CLEAR(), DELETE(), EXISTS(), FETCH(), FIRSTKEY(), NEXTKEY(), SCALAR(),
    TIEHASH()

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

