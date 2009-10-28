package SixteenColors::ResultSet::Pack;

use strict;
use warnings;

use SixteenColors::Archive;
use Image::TextMode::SAUCE;

use base 'DBIx::Class::ResultSet';

sub new_from_file {
    my( $self, $file ) = @_;

    my $archive  = SixteenColors::Archive->new( { file => $file } );
    my $pack     = $self->create( { file_path => $file } );
    my $dir      = $pack->extract;
    my @manifest = $archive->files;

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

    return $pack;
}

1;
