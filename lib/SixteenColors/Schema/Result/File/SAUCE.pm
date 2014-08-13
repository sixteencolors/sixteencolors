package SixteenColors::Schema::Result::File::SAUCE;

use strict;
use warnings;

use parent qw( DBIx::Class );

__PACKAGE__->load_components( qw( Core ) );
__PACKAGE__->table( 'file_sauce' );
__PACKAGE__->add_columns(
    file_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    sauce_id => {
        data_type     => 'char',
        size          => 5,
        is_nullable   => 0,
        default_value => 'SAUCE',
    },
    version => {
        data_type     => 'char',
        size          => 2,
        is_nullable   => 0,
        default_value => '00',
    },
    title => {
        data_type     => 'varchar',
        size          => 35,
        is_nullable   => 1,
    },
    author => {
        data_type   => 'varchar',
        size        => 20,
        is_nullable => 1,
    },
    grp => {
        data_type   => 'varchar',
        size        => 20,
        is_nullable => 1,
    },
    date => {
        data_type   => 'varchar',
        size        => 8,
        is_nullable => 1,
    },
    filesize => {
        data_type     => 'integer',
        is_nullable   => 0,
        default_value => 0,
    },
    filetype_id => {
        data_type     => 'integer',
        is_nullable   => 0,
        default_value => 0,
    },
    datatype_id => {
        data_type     => 'integer',
        is_nullable   => 0,
        default_value => 0,
    },
    tinfo1 => {
        data_type     => 'integer',
        is_nullable   => 0,
        default_value => 0,
    },
    tinfo2 => {
        data_type     => 'integer',
        is_nullable   => 0,
        default_value => 0,
    },
    tinfo3 => {
        data_type     => 'integer',
        is_nullable   => 0,
        default_value => 0,
    },
    tinfo4 => {
        data_type     => 'integer',
        is_nullable   => 0,
        default_value => 0,
    },
    comment_count => {
        data_type     => 'integer',
        is_nullable   => 0,
        default_value => 0,
    },
    flags_id => {
        data_type     => 'integer',
        is_nullable   => 0,
        default_value => 0,
    },
    filler => {
        data_type     => 'varchar',
        size          => 22,
        is_nullable   => 0,
        default_value => ' ' x 22,
    },
    comment_id => {
        data_type     => 'char',
        size          => 5,
        is_nullable   => 0,
        default_value => 'COMNT',
    },
    comments => {
        data_type   => 'text',
        is_nullable => 1,
    },
);
__PACKAGE__->set_primary_key( qw( file_id ) );
__PACKAGE__->belongs_to(
    file => 'SixteenColors::Schema::Result::File',
    'file_id'
);

sub as_sauce_object {
    my $self = shift;

    my %cols = $self->get_columns;
    delete $cols{ file_id };
    $cols{ comments } = [ split( "\n", $cols{ comments } ) ];
    $cols{ has_sauce } = 1;
    $cols{ group } = delete $cols{ grp };

    require Image::TextMode::SAUCE;
    return Image::TextMode::SAUCE->new( \%cols );
}

1;
