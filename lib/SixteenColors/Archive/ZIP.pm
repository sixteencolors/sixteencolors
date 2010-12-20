package SixteenColors::Archive::ZIP;

use strict;
use warnings;

use Archive::Zip;

use base qw( SixteenColors::Archive::Base );

__PACKAGE__->mk_classaccessors( '_archive' );

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new( @_ );

    $self->_archive( Archive::Zip->new( $self->file ) );

    return $self;
}

sub files {
    return shift->_archive->memberNames;
}

sub extract {
    my ( $self, $dir ) = @_;
    my $zip = $self->_archive;

    my $warn = '';
    eval {
        local $SIG{ __WARN__ } = sub { $warn = shift };
        $zip->extractTree;
    };

    return unless $@ || $warn =~ m{Unsupported compression combination}i;

    my $file = $self->file;
    `unzip -o ${file}`;
}

1;
