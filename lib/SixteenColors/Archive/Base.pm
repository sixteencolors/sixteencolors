package SixteenColors::Archive::Base;

use strict;
use warnings;

use base qw( Class::Data::Accessor );

__PACKAGE__->mk_classaccessors( 'file' );

sub new {
    my $class = shift;
    my $self  = shift;

    bless $self, $class;

    return $self;
}

1;
