package SixteenColors::Archive::NonArchive;

use strict;
use warnings;

use File::Basename ();
use File::Copy     ();

use base qw( SixteenColors::Archive::Base );

sub files {
    return File::Basename::basename( shift->file );
}

sub extract {
    File::Copy::cp( shift->file, '.' );
}

1;
