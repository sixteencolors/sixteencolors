package SixteenColors::FileType::Tracker;

use strict;
use warnings;

use parent 'SixteenColors::FileType';

sub generate_surrogates {
    my( $self, $c, $file_db ) = @_;
    my $file = $self->filename;
    my $basename = $file_db->filename;

    # Only full images for now
    my $destfile = $c->path_to( 'root', 'static', 'audio', $file_db->pack->shortname, "${basename}.mp3" );
    $destfile->dir->mkpath;

    system( "xvfb-run vlc -q -Idummy ${file} --sout '#transcode{vcodec=none,acodec=mp3,ab=128,channels=2,samplerate=44100}:file{dst=${destfile}}' vlc://quit >/dev/null 2>&1" );
}

1;
