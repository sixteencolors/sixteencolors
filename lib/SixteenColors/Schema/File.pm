package SixteenColors::Schema::File;

use strict;
use warnings;

use base qw( DBIx::Class );
use JSON::XS ();
use Data::Dump ();
use File::Basename ();
use Encode ();
use GD ();
use Image::TextMode::Loader;
use Image::TextMode::Renderer::GD;
use File::Copy ();

__PACKAGE__->load_components( qw( InflateColumn TimeStamp Core ) );
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
    title => {
        data_type   => 'varchar',
        size        => 80,
        is_nullable => 1,
    },
    type => {
        data_type   => 'varchar',
        size        => 80,
        is_nullable => 1,
    },
    sauce => {
        data_type   => 'text',
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
    annotation => {
        data_type   => 'text',
        is_nullable => 1,
    },
    ctime => {
        data_type     => 'datetime',
        default_value => \'CURRENT_TIMESTAMP',
        set_on_create => 1,
    },
    mtime => {
        data_type     => 'datetime',
        default_value => \'CURRENT_TIMESTAMP',
        set_on_create => 1,
        set_on_update => 1,
    },
);
__PACKAGE__->set_primary_key( qw( id ) );
__PACKAGE__->add_unique_constraint( [ 'pack_id', 'file_path' ] );
__PACKAGE__->resultset_attributes( { order_by => [ 'file_path' ] } );

__PACKAGE__->belongs_to( pack => 'SixteenColors::Schema::Pack', 'pack_id' );

__PACKAGE__->has_many(
    artist_joins => 'SixteenColors::Schema::FileArtistJoin' => 'file_id' );
__PACKAGE__->many_to_many( artists => 'artist_joins' => 'artist',
    { order_by => 'name' }
);

__PACKAGE__->inflate_column(
    "${_}_options",
    {   inflate => sub { JSON::XS::decode_json shift },
        deflate => sub { JSON::XS::encode_json shift },
    }
) for qw( read render );

__PACKAGE__->inflate_column(
    'sauce',
    {   inflate => sub { eval( shift ); },
        deflate => sub { Data::Dump::dump shift },
    }
);

sub store_column {
    my ( $self, $name, $value ) = @_;

    if( $name eq 'file_path' ) {
        my $filename = $value;
        # temporary measure for sub-dirs
        $filename =~ s{/}{-}s;
        Encode::from_to( $filename, 'cp437', 'utf-8' );
        $self->filename( $filename );
    }

    $self->next::method( $name, $value );
}

sub artist_names {
    my $self = shift;
    my @a = $self->artists;

    return 'Artist(s) Unknown' unless @a;

    my $text = ( shift @a )->name;
    while( my $a = shift @a ) {
        $text .= ( @a ? ', ' : ' and ' ) . $a->name;
    }

    return $text;
}

sub is_not_textmode {
    my ( $self ) = @_;

    # rough approximation of extensions which are not to be rendered as textmode
    return $self->is_bitmap || $self->is_audio || $self->is_binary;
}

sub is_bitmap {
    my ( $self ) = @_;
    return $self->filename =~ m{\.(jpg|jpeg|png|gif|bmp)$}i ? 1 : 0;
}

sub is_audio {
    my ( $self ) = @_;
    return $self->filename =~ m{\.(mod|s3m)$}i ? 1 : 0;
}

sub is_binary {
    my ( $self ) = @_;
    # include ripscrip in here for now
    return $self->filename =~ m{\.(exe|com|dll|zip|rar|rip)$}i ? 1 : 0;
}

sub slurp {
    my( $self, $path ) = @_;

    my $dir  = $self->pack->extract;
    my $data = $dir->exists( $self->file_path )->slurp;
    $dir->cleanup;

    return $data;
}

sub generate_thumbnail {
    my( $self, $path ) = @_;

    return if $self->is_not_textmode and !$self->is_bitmap;

    my $dir  = $self->pack->extract;
    my $name = $dir->exists( $self->file_path );
    my $source;

    if( $self->is_bitmap ) {
        $source = GD::Image->new( "$name" );
    }
    else {
        my $textmode = Image::TextMode::Loader->load( [ "$name", $self->read_options ] );
        my $renderer = Image::TextMode::Renderer::GD->new;

        $source = $renderer->fullscale( $textmode, { %{ $self->render_options }, format => 'object' } );
    }

    my $resized = GD::Image->new( 125, $source->height * 125 / $source->width, 1 );
    $resized->copyResampled( $source, 0, 0, 0, 0, $resized->getBounds, $source->getBounds );

    my $final = GD::Image->new( 125, 125, 1 );
    if( $resized->height <= 125 ) {
        $final->copy( $resized, 0, (125 - $resized->height) / 2, 0, 0, $resized->getBounds );
    }
    else {
        $final->copy( $resized, 0, 0, 0, int( rand( $resized->height - 125 ) ), 125, 125 );
    }

    $path->dir->mkpath;
    my $fh = $path->open( 'w' ) or die "cannot write file ($path): $!";
    binmode( $fh );
    print $fh $final->png;
    close( $fh );

    $dir->cleanup;
}

sub generate_fullscale {
    my( $self, $path, $options ) = @_;

    return if $self->is_not_textmode and !$self->is_bitmap;

    my $dir = $self->pack->extract;
    my $name = $dir->exists( $self->file_path );
    $path->dir->mkpath;

    if( $self->is_bitmap ) {
        File::Copy::copy( "$name", "$path" );
        $dir->cleanup;
        return;
    }

    $options = $self->render_options unless $options && keys %$options;

    my $textmode = Image::TextMode::Loader->load( [ "$name", $self->read_options ] );
    my $renderer = Image::TextMode::Renderer::GD->new;
    my $imgdata  = $renderer->fullscale( $textmode, $options );

    my $fh = $path->open( 'w' ) or die "cannot write file ($path): $!";
    binmode( $fh );
    print $fh $imgdata;
    close( $fh );

    $dir->cleanup;
}

sub previous {
    my $self = shift;
    return $self->pack->files( { file_path => { '<' => $self->file_path } }, { order_by => 'file_path DESC', rows => 1 } )->first;
}

sub next {
    my $self = shift;
    return $self->pack->files( { file_path => { '>' => $self->file_path } }, { order_by => 'file_path ASC', rows => 1 } )->first;
}

1;
