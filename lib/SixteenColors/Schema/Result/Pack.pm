package SixteenColors::Schema::Result::Pack;

use strict;
use warnings;

use base qw( DBIx::Class );

use File::Basename ();
use Cwd ();
use SixteenColors::Archive;
use Directory::Scratch;

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'pack' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    canonical_name => {
        data_type   => 'varchar',
        size        => 128,
        is_nullable => 0,
    },
    short_description => {
        data_type   => 'varchar',
        size        => 256,
        is_nullable => 1,
    },
    description => {
        data_type   => 'text',
        is_nullable => 1,
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
    year => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    month => {
        data_type   => 'integer',
        is_nullable => 1,
    },
    ctime => {
        data_type     => 'timestamp',
        default_value => \'CURRENT_TIMESTAMP',
        set_on_create => 1,
    },
    mtime => {
        data_type     => 'timestamp',
        default_value => \'CURRENT_TIMESTAMP',
        set_on_create => 1,
        set_on_update => 1,
    },
);
__PACKAGE__->set_primary_key( qw( id ) );
__PACKAGE__->add_unique_constraint( [ 'canonical_name' ] );
__PACKAGE__->resultset_attributes( { order_by => [ 'year, month, canonical_name' ] } );

__PACKAGE__->has_many(
    group_joins => 'SixteenColors::Schema::Result::PackGroupJoin' => 'pack_id' );
__PACKAGE__->many_to_many( groups => 'group_joins' => 'art_group',
    { order_by => 'name' }
);

__PACKAGE__->has_many( files => 'SixteenColors::Schema::Result::File', 'pack_id' );

sub store_column {
    my ( $self, $name, $value ) = @_;

    if( $name eq 'file_path' ) {
        my $file = File::Basename::basename( $value );
        my $canonical = lc $file;
        $canonical =~ s{\.[^.]+$}{};

        $self->filename( $file );
        $self->canonical_name( $canonical );
    }

    $self->next::method( $name, $value );
}

sub pack_file_location {
    my( $self, $file, $year ) = @_;
    $file ||= $self->filename;
    $year ||= $self->year;

    my $basename = File::Basename::basename( $file );

    my $path = "/static/packs/${year}/${basename}";

    return $path;
}

sub pack_folder_location {
    my( $self ) = shift;

    my $path = $self->pack_file_location( @_ );
    $path =~ s{\.[^.]+$}{};

    return $path;
}

sub extract {
    my( $self ) = @_;
    my $archive = SixteenColors::Archive->new( { file => $self->file_path } );
    my $temp    = Directory::Scratch->new;
    my $cwd     = Cwd::getcwd();
    
    chdir( $temp );
    $archive->extract;
    chdir( $cwd );

    return $temp;
}

my @months = qw( January February March April May June July August September October November December );

sub formatted_date {
    my $self = shift;

    my $month = $self->month;
    my $year  = $self->year;

    return 'Date Unknown' unless $year;
    return $year unless $month;
    return join( ' ', $months[ $month - 1 ],  $year );
}

sub group_name {
    my $self = shift;
    my @g = map { $_->name } $self->groups;
    push @g, 'Group Unknown' unless @g;
    return join ' and ', @g;
}

sub generate_preview {
    my( $self, $path ) = @_;

    my $pic = $self->files( \[ 'lower(filename) = ?', [ plain_value => 'file_id.diz' ] ], { rows => 1 } )->first;

    # Random pic if not DIZ exists
    if( !$pic ) {
        my $files = $self->files( {}, { order_by => 'RANDOM()' } );
        $pic = $files->next until $pic && $pic->is_artwork;
    }

    my $SIZE = 376;
    my $SIZE_S = 176;

    my $dir = $self->extract;
    my $name = $dir->exists( $pic->file_path );

    $path = $path->dir unless $path->is_dir;
    $path->mkpath;

    my $textmode = Image::TextMode::Loader->load( "$name" );
    my $renderer = Image::TextMode::Renderer::GD->new;
    my $source  = $renderer->fullscale( $textmode, { %{ $pic->render_options }, format => 'object' } );

    my( $w, $h ) = $source->getBounds;
    if( $w > $h ) {
        $h = $source->height * $SIZE / $source->width;
        $w = $SIZE; 
    }
    else {
        $w = $source->width * $SIZE / $source->height;
        $h = $SIZE; 
    }

    my $resized = GD::Image->new( $w, $h, 1 );
    $resized->copyResampled( $source, 0, 0, 0, 0, $resized->getBounds, $source->getBounds );

    {
        my $fh = $path->file( $self->canonical_name . '.png' )->open( 'w' ) or die "cannot write file ($path): $!";
        binmode( $fh );
        print $fh $resized->png;
        close( $fh );
    }


    if( $w > $h ) {
        $h = $resized->height * $SIZE_S / $resized->width;
        $w = $SIZE_S; 
    }
    else {
        $w = $resized->width * $SIZE_S / $resized->height;
        $h = $SIZE_S; 
    }

    my $small = GD::Image->new( $w, $h, 1 );
    $small->copyResampled( $resized, 0, 0, 0, 0, $small->getBounds, $resized->getBounds );

    {
        my $fh = $path->file( $self->canonical_name . '-s.png' )->open( 'w' ) or die "cannot write file ($path): $!";
        binmode( $fh );
        print $fh $small->png;
        close( $fh );
    }

    $dir->cleanup;
}

1;
