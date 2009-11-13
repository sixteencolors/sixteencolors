package SixteenColors::ResultSet::Pack;

use strict;
use warnings;

use SixteenColors::Archive;
use Image::TextMode::SAUCE;
use Try::Tiny;

use base 'DBIx::Class::ResultSet';

sub new_from_file {
    my( $self, $file, $c ) = @_;

    my $archive  = SixteenColors::Archive->new( { file => $file } );
    my @manifest = $archive->files;

    my $schema = $self->result_source->schema;
    $schema->txn_begin;

    my $pack;
    my $pack_file = $c->path_to( 'root', $self->result_class->pack_file_location( $file ) );

    try {
        $pack_file->dir->mkpath;
        File::Copy::copy( $file, "${pack_file}" );
        
        $pack = $self->create( { file_path => "${pack_file}" } );
        my $dir = $pack->extract;

        for my $f ( @manifest ) {
            next unless my $name = $dir->exists( $f );
            next if -d $name;

            my $sauce = Image::TextMode::SAUCE->new;

            my $fh = $name->open( 'r' );
            $sauce->read( $fh );
            close( $fh );

            $pack->add_to_files(
                {   file_path => $f,
                    ( $sauce->has_sauce ? ( sauce => $sauce ) : () )
                }
            );
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

1;
