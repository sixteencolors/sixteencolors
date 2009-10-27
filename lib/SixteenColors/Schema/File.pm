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
    render_options => {
        data_type     => 'varchar',
        default_value => '{}',
        size          => 80,
        is_nullable   => 0,
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

__PACKAGE__->belongs_to( pack => 'SixteenColors::Schema::Pack', 'pack_id' );

__PACKAGE__->has_many(
    artist_joins => 'SixteenColors::Schema::FileArtistJoin' => 'file_id' );
__PACKAGE__->many_to_many( artists => 'artist_joins' => 'artist',
    { order_by => 'name' }
);

__PACKAGE__->inflate_column(
    'render_options',
    {   inflate => sub { JSON::XS::decode_json shift },
        deflate => sub { JSON::XS::encode_json shift },
    }
);

__PACKAGE__->inflate_column(
    'sauce',
    {   inflate => sub { eval( shift ) },
        deflate => sub { Data::Dump::dump( shift ) },
    }
);

sub store_column {
    my ( $self, $name, $value ) = @_;

    if( $name eq 'file_path' ) {
        my $basename = File::Basename::basename( $value );
        Encode::from_to( $basename, 'cp437', 'utf-8' );
        $self->filename( $basename );
    }

    $self->next::method( $name, $value );
}

sub artist_names {
    my $self = shift;
    my $a = $self->artists;
    return $a->count ? join( ', ', map { $_->name } $a->all ) : 'Artist(s) Unknown';
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
    return $self->filename =~ m{\.(exe|com|zip|rip)$}i ? 1 : 0;
}

sub generate_thumbnail {
    my( $self, $path ) = @_;

    my $dir = $self->pack->extract;

    my $name = $dir->exists( $self->file_path );
    my $imgdata;

    if( $self->is_bitmap ) {
        my $source = GD::Image->new( "$name" );
        my $resized = GD::Image->new( 80, $source->height * 80 / $source->width, 1 );
        $resized->copyResampled( $source, 0, 0, 0, 0, $resized->getBounds, $source->getBounds );
        $imgdata = $resized->png;
    }
    elsif( $self->is_not_textmode ) {
        return;
    }
    else {
        my $textmode = Image::TextMode::Loader->load( "$name" );
        my $renderer = Image::TextMode::Renderer::GD->new;

        $imgdata = $renderer->thumbnail( $textmode, $self->render_options );
    }

    $path->dir->mkpath;
    my $fh = $path->open( 'w' ) or die "cannot write file ($path): $!";
    binmode( $fh );
    print $fh $imgdata;
    close( $fh );

    $dir->cleanup;
}

sub generate_fullscale {
    my( $self, $path ) = @_;

    my $dir = $self->pack->extract;

    my $name = $dir->exists( $self->file_path );
    my $imgdata;

    if( $self->is_bitmap ) {
        $imgdata = $name->slurp;
    }
    elsif( $self->is_not_textmode ) {
        return;
    }
    else {
        my $textmode = Image::TextMode::Loader->load( "$name" );
        my $renderer = Image::TextMode::Renderer::GD->new;

        $imgdata = $renderer->fullscale( $textmode, $self->render_options );
    }

    $path->dir->mkpath;
    my $fh = $path->open( 'w' ) or die "cannot write file ($path): $!";
    binmode( $fh );
    print $fh $imgdata;
    close( $fh );

    $dir->cleanup;
}

1;
