package SixteenColors::Form::Pack;
 
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
 
has '+widget_wrapper' => ( default => 'Bootstrap3' );

has '+item_class' => ( default => 'Pack' );
has_field 'year' => ( type => 'Integer' );
has_field 'month' => ( type => 'Integer' );
has_field 'approved' => ( type => 'Boolean' );
has_field 'groups' => ( type => 'Repeatable' );
has_field 'groups.id' => ( type => 'PrimaryKey' );
has_field 'groups.name'=> ( label => 'Group', element_class => [ 'group-typeahead' ] );
has_field 'tags' => ( type => 'Repeatable' );
has_field 'tags.tag' => ( element_class => [ 'tag-typeahead' ] );
has_field 'submit' => ( type => 'Submit', value => 'Submit' );
 
no HTML::FormHandler::Moose;

1;
