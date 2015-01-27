package SixteenColors::FileType::Textmode;

use strict;
use warnings;

use Image::TextMode::Loader;
use Image::TextMode::Renderer::GD;

use parent 'SixteenColors::FileType';

sub get_source {
    my $self = shift;
    my $file = $self->filename;
    return Image::TextMode::Loader->load( "$file" )->as_ascii;
}

sub generate_surrogates {
    my( $self, $c, $file_db ) = @_;
    my $file = $self->filename;
    my $basename = $file_db->filename;

    my $textmode = Image::TextMode::Loader->load( [ "$file", $file_db->read_options ] );
    my $renderer = Image::TextMode::Renderer::GD->new;

    # Only full images for now
    my $raw = $renderer->fullscale( $textmode, { %{$file_db->render_options}, format => 'object' } );
    my $destfile = $c->path_to( 'root', 'static', 'images', 'f', $file_db->pack->shortname, "${basename}.png" );
    $destfile->dir->mkpath;

    my $fh = $destfile->open( 'w' ) or die "cannot write file ($destfile): $!";
    binmode( $fh );
    print $fh ref $raw ? $raw->png : $raw;
    close( $fh );
}

1;
