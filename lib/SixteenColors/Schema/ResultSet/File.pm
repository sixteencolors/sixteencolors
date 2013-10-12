package SixteenColors::Schema::ResultSet::File;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet::Data::Pageset';

sub random {
    my $self = shift;
    $self->search( {}, { order_by => 'RAND()' } );
}

sub TO_JSON {
    my $self = shift;
    return [
        map {
            my $p = $_->pack;
            my $uri = join( '/', '/pack', $p->canonical_name, $_->filename );
            {   filename  => $_->filename,
                thumbnail => "$uri/preview",
                fullsize  => "$uri/fullscale",
                uri       => $uri,
                pack      => {
                    filename => $p->filename,
                    name     => $p->canonical_name,
                    uri      => join( '/', '/pack', $p->canonical_name )
                },
                file_location => join( '/',
                    '/pack', $p->canonical_name, $_->filename, 'download' )
            }
            } $self->all
    ];
}

1;
