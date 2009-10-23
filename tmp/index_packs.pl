use strict;
use warnings;

use lib 'lib';

use SixteenColors;
use SixteenColors::Archive;

my @files   = @ARGV;
my $schema  = SixteenColors->model( 'DB' )->schema;

for my $file ( @files ) {
    print "Indexing ${file}\n";

    my $archive = SixteenColors::Archive->new( { file => $file } );
    $archive->add_to_db( $schema );
}
