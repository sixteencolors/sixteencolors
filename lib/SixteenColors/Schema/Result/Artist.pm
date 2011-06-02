package SixteenColors::Schema::Result::Artist;

use strict;
use warnings;

use base qw( DBIx::Class );

use Text::Markdown ();

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'artist' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    name => {
        data_type   => 'varchar',
        size        => 512,
        is_nullable => 0,
    },
    shortname => {
        data_type   => 'varchar',
        size        => 25,
        is_nullable => 0,
    },
    formerly_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 1,
    },
    bio => {
        data_type   => 'text',
        is_nullable => 1,
    },
    ctime => {
        data_type     => 'timestamp',
        default_value => \'CURRENT_TIMESTAMP',
        set_on_create => 1,
    },
    mtime => {
        data_type     => 'timestamp',
        is_nullable   => 1,
        set_on_create => 1,
        set_on_update => 1,
    },
);
__PACKAGE__->set_primary_key( qw( id ) );
__PACKAGE__->add_unique_constraint( [ 'shortname' ] );

__PACKAGE__->has_many(
    file_joins => 'SixteenColors::Schema::Result::FileArtistJoin' =>
        'artist_id' );
__PACKAGE__->many_to_many( files => 'file_joins' => 'file' );

__PACKAGE__->has_many(
    group_joins => 'SixteenColors::Schema::Result::ArtistGroupJoin' =>
        'artist_id' );
__PACKAGE__->many_to_many( groups => 'group_joins' => 'art_group' );

__PACKAGE__->belongs_to(
    formerly => 'SixteenColors::Schema::Result::Artist',
    'formerly_id'
);

sub store_column {
    my ( $self, $name, $value ) = @_;

    if ( $name eq 'name' ) {
        my $short = lc $value;
        $short =~ s{[^a-z0-9]+}{_}g;
        $short =~ s{^_}{};
        $short =~ s{_$}{};
        $self->shortname( $short );
    }

    $self->next::method( $name, $value );
}

sub bio_as_html {
    return Text::Markdown::markdown( shift->bio );
}

1;
