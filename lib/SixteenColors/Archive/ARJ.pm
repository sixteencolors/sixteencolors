package SixteenColors::Archive::ARJ;

use strict;
use warnings;

use base qw( SixteenColors::Archive::Base );

sub files {
    my $self = shift;

    my $file = $self->file;
    my $output = qx( arj l $file 2>/dev/null );

    my $cap = 0;
    my @files;
    for ( split( /\n/, $output ) ) {
        if( !$cap && m{^[- ]+$} ) {
            $cap++;
            next;
        }

        next if !$cap;

        last if $cap && m{^[- ]+$};

        if( $cap ) {
            push @files, ( m{(.+?)\s{2,}} );
        }
    }

    return @files;
}

sub extract {
    my( $self, $dir ) = @_;
    my $file = $self->file;

    qx( arj e $file );
}

1;
