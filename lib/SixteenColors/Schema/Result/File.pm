package SixteenColors::Schema::Result::File;

use strict;
use warnings;

use parent qw( DBIx::Class );

use File::Basename ();
use JSON::XS ();
use Encode ();

__PACKAGE__->load_components( qw( Tree::NestedSet TimeStamp Core ) );
__PACKAGE__->table( 'file' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    pack_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    filename => {
        data_type   => 'varchar',
        size        => 128,
        is_nullable => 0,
    },
    file_path => {
        data_type   => 'varchar',
        size        => 512,
        is_nullable => 0,
    },
    type => {
        data_type   => 'varchar',
        size        => 80,
        is_nullable => 1,
    },

    # JSON-encoded hashref of options for use when reading in files
    # e.g. force 80 columns
    # { "width": 80 }
    read_options => {
        data_type     => 'varchar',
        default_value => '{}',
        size          => 128,
        is_nullable   => 0,
    },

    # JSON-encoded hashref of options for use when rendering for display
    # e.g. force Amiga font
    # { "font": "Amiga" }
    render_options => {
        data_type     => 'varchar',
        default_value => '{}',
        size          => 128,
        is_nullable   => 0,
    },

    blocked => {
        data_type     => 'boolean',
        default_value => 0,
        is_nullable   => 1,
    },

    # Tree columns for DBIx::Class::Tree::NestedSet
    root_id => {
        data_type     => 'integer',
        is_nullable   => 1,
    },
    lft => {
        data_type     => 'integer',
        is_nullable   => 0,
    },
    rgt => {
        data_type     => 'integer',
        is_nullable   => 0,
    },
    level => {
        data_type     => 'integer',
        is_nullable   => 0,
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
__PACKAGE__->add_unique_constraint( [ 'pack_id', 'filename' ] );
__PACKAGE__->resultset_attributes( {
    order_by => [ 'filename' ],
    where    => { 'me.blocked' => 0 },
} );

__PACKAGE__->tree_columns( {
    root_column  => 'root_id',
    left_column  => 'lft',
    right_column => 'rgt',
    level_column => 'level',
} );

__PACKAGE__->belongs_to(
    pack => 'SixteenColors::Schema::Result::Pack',
    'pack_id'
);

__PACKAGE__->has_many(
    artist_joins => 'SixteenColors::Schema::Result::FileArtistJoin' =>
        'file_id' );
__PACKAGE__->many_to_many(
    artists => 'artist_joins' => 'artist',
    { order_by => 'name' }
);

__PACKAGE__->might_have(
    file_source => 'SixteenColors::Schema::Result::File::Source',
    'file_id',
    { proxy => [ 'source' ], }
);
__PACKAGE__->might_have(
    sauce => 'SixteenColors::Schema::Result::File::SAUCE',
    'file_id',
);

__PACKAGE__->has_many(
    tags => 'SixteenColors::Schema::Result::File::Tag' =>
        'file_id' );

__PACKAGE__->inflate_column(
    "${_}_options",
    {   inflate => sub { JSON::XS::decode_json shift },
        deflate => sub { JSON::XS::encode_json shift },
    }
) for qw( read render );

sub store_column {
    my ( $self, $name, $value ) = @_;

    if ( $name eq 'file_path' ) {
        $value = Encode::decode( 'cp437', $value );
        if( !$self->filename ) {
            my $filename = File::Basename::basename( $value );
            $self->filename( $filename );
        }
    }

    $self->next::method( $name, $value );
}

sub add_sauce_from_obj {
    my( $self, $sauce ) = @_;

    return unless $sauce->has_sauce;

    my %cols = %$sauce;
    delete $cols{ has_sauce };
    $cols{ comments } = join( "\n", @{ $cols{ comments } } );
    $cols{ grp } = delete $cols{ group };

    return $self->create_related( 'sauce', \%cols );
}

sub TO_JSON {
    my $self = shift;
    return { $self->get_columns };
}

1;
