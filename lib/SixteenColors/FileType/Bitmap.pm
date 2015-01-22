package SixteenColors::FileType::Bitmap;

use strict;
use warnings;

use parent 'SixteenColors::FileType';

use File::Copy ();

sub generate_surrogates {
    my( $self, $c, $file_db ) = @_;
    my $file = $self->filename;
    my $basename = $file_db->filename;

    # Only full images for now
    my $destfile = $c->path_to( 'root', 'static', 'images', 'f', $file_db->pack->shortname, $basename );
    $destfile->dir->mkpath;
    File::Copy::copy( "$file", "$destfile" );
}

1;
