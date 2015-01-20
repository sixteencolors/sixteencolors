package SixteenColors::FileType::Ripscrip;

use strict;
use warnings;

use parent 'SixteenColors::FileType';

use File::chdir;
use File::Copy ();

sub generate_surrogates {
    my( $self, $c, $file_db ) = @_;
    my $file = $self->filename;
    my $basename = $file_db->filename;

    # Only full images for now
    my $destfile = $c->path_to( 'root', 'static', 'images', 'f', $file_db->pack->shortname, "${basename}.png" );
    $destfile->dir->mkpath;

    {
        local $CWD = $file->dir;
        system( "xvfb-run PabloDraw.Console.exe -p=win ${basename} ${basename}.png >/dev/null 2>&1" );
        File::Copy::copy( "$file", "$destfile" );
    }
}

1;
