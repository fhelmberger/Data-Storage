package Data::Storage::DBIC;
use warnings;
use strict;
use Error::Hierarchy::Util qw(assert_defined load_class);
use Error ':try';
our $VERSION = '0.11';
use base 'Data::Storage::DBI';
#<<<
__PACKAGE__
    ->mk_scalar_accessors(qw(schema))
    ->mk_abstract_accessors(qw(SCHEMA_CLASS));
#>>>

sub is_connected {
    my $self         = shift;
    my $is_connected = ref($self->schema)
      && $self->schema->storage->connected;
    $self->log->debug('storage [%s] is %s',
        $self->dbname, $is_connected ? 'connected' : 'not connected');
    $is_connected;
}

sub connect {
    my $self = shift;
    return if $self->is_connected;
    assert_defined $self->$_, sprintf "called without %s argument.", $_
      for qw/dbname dbuser dbpass/;
    $self->log->debug('connecting to storage [%s] as [%s/%s]',
        $self->dbname, $self->dbuser, $self->dbpass);
    try {
        load_class $self->SCHEMA_CLASS, 0;
        my $class = $self->SCHEMA_CLASS;
        $self->schema(
            $class->connect(
                $self->dbname, $self->dbuser,
                $self->dbpass, $self->get_connect_options
            )
        );

        # XXX no global commit and rollback in DBIx::Class, so we have to
        # create a transaction?
        $self->schema->txn_begin;
    }
    catch Error with {
        my $E = shift;
        throw Error::Hierarchy::Internal::CustomMessage(
            custom_message => sprintf
              "couldn't connect to storage [%s (%s/%s)]: %s",
            $self->dbname,
            $self->dbuser,
            $self->dbpass,
            $E
        );
    };
}

sub disconnect {
    my $self = shift;
    return unless $self->is_connected;
    $self->rollback_mode ? $self->rollback : $self->commit;
    $self->log->debug('disconnecting from storage [%s]', $self->dbname);
    $self->schema->storage->disconnect;
}

sub rollback {
    my $self = shift;

    # avoid "rollback ineffective with AutoCommit enabled" error
    # return if $self->AutoCommit;
    $self->schema->txn_rollback;
    $self->log->debug('did rollback');
}

sub commit {
    my $self = shift;
    return if $self->rollback_mode;

    # avoid "commit ineffective with AutoCommit enabled" error
    return if $self->AutoCommit;
    $self->schema->txn_commit;
    $self->log->debug('did commit');
}

sub lazy_connect {
    my $self = shift;

    # not supported in DBIx::Class?
    $self->connect(@_);
}
1;
