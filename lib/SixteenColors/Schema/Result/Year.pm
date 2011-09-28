package SixteenColors::Schema::Result::Year;

use base 'DBIx::Class::Core';

__PACKAGE__->table_class( 'DBIx::Class::ResultSource::View' );

__PACKAGE__->table( 'year' );
__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(
  'SELECT year, count(*) packs FROM pack GROUP BY year ORDER BY year'
);

__PACKAGE__->add_columns(
    year => {
        data_type => 'integer',
    },
    packs => {
        data_type => 'integer',
    },
);
__PACKAGE__->set_primary_key( 'year' );

1;
