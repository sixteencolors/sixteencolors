package SixteenColors::Schema::Result::Tag;

use base qw( DBIx::Class::Core );

__PACKAGE__->table_class( 'DBIx::Class::ResultSource::View' );

__PACKAGE__->table( 'tag' );
__PACKAGE__->result_source_instance->is_virtual( 1 );
__PACKAGE__->result_source_instance->view_definition(
    "SELECT DISTINCT tag FROM (
       SELECT tag FROM pack_tag
       UNION SELECT tag FROM file_tag
       UNION SELECT tag FROM group_tag
       UNION SELECT tag FROM artist_tag
    ) as tag ORDER BY tag"
);

__PACKAGE__->add_columns(
    'tag' => {
      data_type => 'varchar',
      size      => 128,
    },
);

1;
