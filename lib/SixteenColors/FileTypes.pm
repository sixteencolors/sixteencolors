package SixteenColors::FileTypes;

use strict;
use warnings;

use Class::Load ();

my %types = (
    application => [ qw( com exe ) ],
    archive     => [ qw( arj rar zip ) ],
    audio       => [ qw( mp3 m4a ogg oga ) ],
    binary      => [ qw( dat dll ) ],
    bitmap      => [ qw( bmp gif jpeg jpg png ) ],
    ripscrip    => [ qw( rip ) ],
    textmode    => [ qw( adf ans asc ata avt bin cia diz ice idf lgo nfo pcb tnd txt xb xbin ) ],
    tracker     => [ qw( it mod s3m xm ) ],
);

my @art_types = qw( bitmap ripscrip textmode );

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
    $ext //= '';

    return $exts{ lc $ext } || 'unknown';
}

sub get_object {
    my( $self, $filename ) = @_;
    my $type  = $self->get_type( $filename );
    my $class = 'SixteenColors::FileType::' . ucfirst $type;
    Class::Load::load_class( $class );
    return $class->new( $filename );
}

sub artwork_types {
    return @art_types;
}

sub is_artwork {
    my( $self, $type ) = @_;
    return grep { $_ eq $type } @art_types;
}

1;
