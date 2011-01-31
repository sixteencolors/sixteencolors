package SixteenColors::Schema::Result::Fulltext;

use strict;
use warnings;

use base qw( DBIx::Class );

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'file_fulltext' );
__PACKAGE__->add_columns(
    file_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    fulltext => {
        data_type   => 'text',
        is_nullable => 0,
    },
);
__PACKAGE__->set_primary_key( 'file_id' );
__PACKAGE__->belongs_to( file => 'SixteenColors::Schema::Result::File', 'file_id' );

sub store_column {
    my ( $self, $name, $value ) = @_;

    if ( $name eq 'fulltext' ) {
        $value = $self->_clean_text( $value );
    }

    $self->next::method( $name, $value );
}

sub _clean_text {
    my ( $self, $value ) = @_;

    $value =~ s{[^[:alnum:]]}{ }gs;
    $value =~ s{\s+}{ }gs;
    $value =~ s{^\s+}{}s;
    $value =~ s{\s+$}{}s;

    return $value;
}

1;
