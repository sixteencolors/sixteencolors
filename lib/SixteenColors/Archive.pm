package SixteenColors::Archive;

use strict;
use warnings;

use SixteenColors::Archive::ZIP;
use SixteenColors::Archive::RAR;
use SixteenColors::Archive::ARJ;
use SixteenColors::Archive::NonArchive;

our $VERSION = '0.01';

my %types = (
    rar => 1,
    zip => 1,
    arj => 1,
);

sub new {
    my $class = shift;
    my $options = shift || {};

    my $file = $options->{ file };

    die 'No file specified!'   unless defined $file;
    die 'File does not exist!' unless -e $file;
    die 'Directory specified!' if -d $file;

    my ( $ext ) = $file =~ m{([^.]+)$};

    my $archive_class = 'SixteenColors::Archive::'
        . ( $types{ lc $ext } ? uc( $ext ) : 'NonArchive' );

    return $archive_class->new( { file => $file } );
}

1;

__END__

=head1 NAME

SixteenColors::Archive - Factory for archive files

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 new

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
