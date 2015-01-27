package SixteenColors::FileType::Ripscrip;

use strict;
use warnings;

use parent 'SixteenColors::FileType';

sub generate_surrogates {
    my( $self, $c, $file_db ) = @_;
    my $file = $self->filename;
    my $basename = $file_db->filename;

    # Only full images for now
    my $destfile = $c->path_to( 'root', 'static', 'images', 'f', $file_db->pack->shortname, "${basename}.png" );
    $destfile->dir->mkpath;

    system( "xvfb-run -a PabloDraw.Console.exe -p=win --convert ${file} -out ${destfile} >/dev/null 2>&1" );
}

1;
