package SixteenColors::Archive::RAR;

use strict;
use warnings;

use base qw( SixteenColors::Archive::Base );

sub files {
    my $self = shift;

    my $file = $self->file;
    my $output = qx( unrar l -c- $file 2>/dev/null );

    my $cap = 0;
    my @files;
    for ( split( /\n/, $output ) ) {
        if( !$cap && m{^-+$} ) {
            $cap++;
            next;
        }

        next if !$cap;

        last if $cap && m{^-+$};

        if( $cap ) {
            push @files, ( m{^\s([^\s]+)} );
        }
    }

    return @files;
}

sub extract {
    my( $self, $dir ) = @_;
    my $file = $self->file;

    qx( unrar e $file );
}

1;
