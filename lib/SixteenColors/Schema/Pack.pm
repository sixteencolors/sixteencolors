package SixteenColors::Schema::Pack;

use strict;
use warnings;

use base qw( DBIx::Class );

use File::Basename ();
use Cwd ();
use SixteenColors::Archive;
use Directory::Scratch;

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'pack' );
__PACKAGE__->resultset_class( 'SixteenColors::ResultSet::Pack' );
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
        is_nullable => 1,
    },
    month => {
        data_type   => 'integer',
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
__PACKAGE__->add_unique_constraint( [ 'canonical_name' ] );

__PACKAGE__->has_many(
    group_joins => 'SixteenColors::Schema::PackGroupJoin' => 'pack_id' );
__PACKAGE__->many_to_many( groups => 'group_joins' => 'art_group',
    { order_by => 'name' }
);

__PACKAGE__->has_many( files => 'SixteenColors::Schema::File', 'pack_id' );

sub store_column {
    my ( $self, $name, $value ) = @_;

    if( $name eq 'file_path' ) {
        my $file = File::Basename::basename( $value );
        my $canonical = $file;
        $canonical =~ s{\.[^.]+$}{};

        $self->filename( $file );
        $self->canonical_name( $canonical );
    }

    $self->next::method( $name, $value );
}

sub pack_file_location {
    my( $self, $filename ) = @_;
    $filename ||= $self->filename;

    my $basename = File::Basename::basename( $filename );

    my $first  = lc( substr( $basename, 0, 1 ) );
    my $second = lc( substr( $basename, 0, 2 ) );
    my $path = "/static/packs/${first}/${second}/${basename}";

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

    my $file_id_diz = $self->files( { filename => [ 'FILE_ID.DIZ', 'file_id.diz' ] } )->first;

    return unless $file_id_diz;

    my $dir = $self->extract;
    my $name = $dir->exists( $file_id_diz->file_path );
    $path->dir->mkpath;

    my $textmode = Image::TextMode::Loader->load( "$name" );
    my $renderer = Image::TextMode::Renderer::GD->new;
    my $imgdata  = $renderer->fullscale( $textmode, $file_id_diz->render_options );

    my $fh = $path->open( 'w' ) or die "cannot write file ($path): $!";
    binmode( $fh );
    print $fh $imgdata;
    close( $fh );

    $dir->cleanup;
}

1;
