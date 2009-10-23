package SixteenColors::Archive::Base;

use strict;
use warnings;

use base qw( Class::Data::Accessor );

use Directory::Scratch;
use Data::Dump     ();
use File::Basename ();
use Image::TextMode::SAUCE;

__PACKAGE__->mk_classaccessors( 'file' );

sub new {
    my $class = shift;
    my $self  = shift;

    bless $self, $class;

    return $self;
}

sub add_to_db {
    my ( $self, $schema ) = @_;

    my $temp     = Directory::Scratch->new;
    my @manifest = $self->files;
    chdir( $temp );
    $self->extract;

    my $pack = $schema->resultset( 'Pack' )->create(
        {   file_path => $self->file,
            filename  => File::Basename::basename( $self->file )
        }
    );

    for my $f ( @manifest ) {
        next unless my $name = $temp->exists( $f );

        my $sauce = Image::TextMode::SAUCE->new;

        open( my $fh, '<', $name );
        $sauce->read( $fh );
        close( $fh );

        $pack->add_to_files(
            {   filename => $f,
                sauce    => $sauce->has_sauce
                ? Data::Dump::dump( $sauce )
                : undef
            }
        );
    }
}

1;
