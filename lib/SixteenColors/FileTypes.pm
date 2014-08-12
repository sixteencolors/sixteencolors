package SixteenColors::FileTypes;

use strict;
use warnings;

my %types = (
    application => [ qw( com exe ) ],
    archive     => [ qw( arj rar zip ) ],
    audio       => [ qw( mp3 m4a ogg oga ) ],
    binary      => [ qw( dat dll ) ],
    bitmap      => [ qw( bmp gif jpeg jpg png ) ],
    ripscrip    => [ qw( rip ) ],
    textmode    => [ qw( adf ans asc ata avt bin cia ice idf pcb tnd txt xb xbin ) ],
    tracker     => [ qw( it mod s3m xm ) ],
);

my %exts;
for my $type ( keys %types ) {
    $exts{ $_ } = $type for @{ $types{ $type } };
}

sub new {
    return bless {}, shift;
}

sub get_type {
    my( $self, $filename ) = @_;
    my( $ext ) = $filename =~ m{\.([a-z0-9]+)$}i;

    return $exts{ $ext } || 'unknown';
}

1;
