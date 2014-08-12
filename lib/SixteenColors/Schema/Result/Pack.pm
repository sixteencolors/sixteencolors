package SixteenColors::Schema::Result::Pack;

use strict;
use warnings;

use parent 'DBIx::Class';

use File::Basename ();
use Text::CleanFragment ();
use Archive::Extract::Libarchive;
use SixteenColors::FileTypes;
use Image::TextMode::Loader;
use Image::TextMode::SAUCE;

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'pack' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    file_path => {
        data_type   => 'varchar',
        size        => 512,
        is_nullable => 0,
    },
    filename => {
        data_type   => 'varchar',
        size        => 128,
        is_nullable => 0,
    },
    shortname => {
        data_type   => 'varchar',
        size        => 128,
        is_nullable => 0,
    },
    year => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    month => {
        data_type   => 'integer',
        is_nullable => 1,
    },
    approved => {
        data_type     => 'boolean',
        default_value => 0,
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
__PACKAGE__->add_unique_constraint( [ 'filename' ] );
__PACKAGE__->add_unique_constraint( [ 'shortname' ] );
__PACKAGE__->resultset_attributes( {
    order_by => [ 'year, month, filename' ],
    where    => { approved => 1 },
} );

__PACKAGE__->has_many(
    files => 'SixteenColors::Schema::Result::File',
    'pack_id'
);

__PACKAGE__->has_many(
    group_joins => 'SixteenColors::Schema::Result::PackGroupJoin' =>
        'pack_id' );
__PACKAGE__->many_to_many(
    groups => 'group_joins' => 'art_group',
    { order_by => 'name' }
);

sub store_column {
    my ( $self, $name, $value ) = @_;

    if ( $name eq 'file_path' ) {
        my $filename = lc File::Basename::basename( $value );
        $self->filename( $filename );
        if( !$self->shortname ) {
            my $short = Text::CleanFragment::clean_fragment( $filename );
            $short =~ s{\.zip$}{};
            $self->shortname( $short );
        }
    }

    $self->next::method( $name, $value );
}

sub TO_JSON {
    my $self = shift;
    return { $self->get_columns };
}

sub index {
    my $self = shift;

    my $archive = Archive::Extract::Libarchive->new( archive => $self->file_path );
    my $tempdir = Directory::Scratch->new();

    my $result = $archive->extract( to => "$tempdir" );
    if( !$result ) {
        die $archive->error;
    }

    my $root = $self->add_to_files( {
        file_path => '/',
        type      => 'directory'
    } );

    _index_archive( $self, $root, $archive, $tempdir );
}

sub _index_archive {
    my( $pack, $root, $archive, $tempdir ) = @_;

    my %paths = ( '/' => $root );
    my $types = SixteenColors::FileTypes->new;

    for my $fs_file ( @{ $archive->files } ) {
        my $dir = File::Basename::dirname( $fs_file );
        my $node;

        $dir = '/' if $dir eq '.';

        # Store the directory tree leading to this file
        if( !defined( $node = $paths{ $dir || '/' } ) ) {
            my $path = '';
            for my $part ( split( m{/}, $dir ) ) {
                $path .= '/' if $path;
                $path .= $part;

                next if $paths{ $path };

                $node = $root->add_to_children( {
                    pack      => $pack,
                    file_path => $path,
                    type      => 'directory'
                } );

                $paths{ $path } = $node;
            }
        }

        my $newfile = $node->add_to_children( {
            pack      => $pack,
            file_path => $fs_file,
            type      => $types->get_type( $fs_file )
        } );

        my $sauce = Image::TextMode::SAUCE->new;
        my $local = $tempdir->exists( $fs_file );

        open( my $fh, '<', $local );
        $sauce->read( $fh );
        close( $fh );

        if( $sauce->has_sauce ) {
            $newfile->add_sauce_from_obj( $sauce );
        }

        if( $newfile->type eq 'textmode' ) {
            $newfile->fulltext( Image::TextMode::Loader->load( "$local" )->as_ascii );
        }
        elsif( $newfile->type eq 'archive' ) {
            my $archive = Archive::Extract::Libarchive->new( archive => "$local" );
            my $tempdir = Directory::Scratch->new();

            my $result = $archive->extract( to => "$tempdir" );
            if( !$result ) {
                die $archive->error;
            }

            _index_archive( $pack, $newfile, $archive, $tempdir );
        }
    }
}

1;
