package SixteenColors::Schema::ResultSet::Pack;

use strict;
use warnings;

use SixteenColors::Archive;
use Image::TextMode::SAUCE;
use Try::Tiny;

use base 'DBIx::Class::ResultSet::Data::Pageset';

sub new_from_file {
    my ( $self, $file, $year, $c ) = @_;

    my ( $warn, $archive );
    eval {
        local $SIG{ __WARN__ } = sub { $warn = shift };
        $archive = SixteenColors::Archive->new( { file => $file } );
    };

    if ( $warn or $@ ) {
        warn sprintf "Problem indexing pack '%s': %s", $file, $warn || $@;
        return;
    }

    my @manifest = $archive->files;

    my $schema = $self->result_source->schema;
    $schema->txn_begin;

    my $pack;
    my $pack_file = $c->path_to( 'root',
        $self->result_class->pack_file_location( $file, $year ) );

    try {
        $pack_file->dir->mkpath;
        File::Copy::copy( $file, "${pack_file}" ) unless -e "${pack_file}";

        $pack
            = $self->create( { file_path => "${pack_file}", year => $year } );
        my $dir = $pack->extract;

        for my $f ( @manifest ) {
            next unless my $name = $dir->exists( $f );
            next if -d $name;

            my $sauce = Image::TextMode::SAUCE->new;

            my $fh = $name->open( 'r' );
            $sauce->read( $fh );
            close( $fh );

            my $newfile = $pack->add_to_files(
                {   file_path => $f,
                    ( $sauce->has_sauce ? ( sauce => $sauce ) : () )
                }
            );

            next unless $newfile->is_textmode;

            $newfile->fulltext(
                Image::TextMode::Loader->load( "$name" )->as_ascii );
        }
    }
    catch {
        unlink $pack_file;
        $schema->txn_rollback;
        die $_;
    };

    $schema->txn_commit;
    return $pack;
}

sub recent {
    my ( $self ) = @_;
    return $self->search( {}, { order_by => 'ctime DESC', rows => 9 } );
}

sub TO_JSON {
    my $self = shift;
    return {
        return [
            map {
                {   name     => $_->canonical_name,
                    filename => $_->filename,
                    year     => $_->year,
                    month    => $_->month
                }
                } $self->all
        ]
    };
}

1;
