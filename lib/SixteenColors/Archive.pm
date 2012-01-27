package SixteenColors::Archive;

use Moose;
use Moose::Util::TypeConstraints;
use Archive::Zip;
use Directory::Scratch;

subtype 'SixteenColors::Types::Filename',
    as 'Str',
    where { defined $_ && -e $_ && -f $_ };

subtype 'SixteenColors::Types::Archive::Zip' =>
    as class_type( 'Archive::Zip' );

coerce 'SixteenColors::Types::Archive::Zip',
    from 'SixteenColors::Types::Filename',
    via { Archive::Zip->new( $_ ) };

has filename => ( is => 'ro', isa => 'SixteenColors::Types::Filename' );

has archive => (
    is      => 'ro',
    isa     => 'SixteenColors::Types::Archive::Zip',
    lazy    => 1,
    builder => '_build_archive',
    coerce  => 1
);

sub _build_archive { return shift->filename }

sub files {
    return shift->archive->memberNames;
}

sub extract {
    my ( $self, $dir ) = @_;
    my $zip = $self->archive;
    $dir = Directory::Scratch->new; # custom extraction dir not yet supported

    my $warn = '';
    eval {
        local $SIG{ __WARN__ } = sub { $warn = shift };
        $zip->extractTree( '.', $dir );
    };

    return $dir unless $@ || $warn =~ m{Unsupported compression combination}i;

    my $file = $self->file;
    `unzip -o ${file} -d $dir`;
    return $dir;
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

SixteenColors::Archive - Wrapper around archive files

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
