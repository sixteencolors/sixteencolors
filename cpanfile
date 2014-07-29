requires 'DBIx::Class';
requires 'DBIx::Class::TimeStamp';
requires 'DBIx::Class::Tree::NestedSet';
requires 'Text::CleanFragment';
requires 'JSON::XS';

recommends 'SQL::Translator'; # To deploy the schema

on 'develop'=> sub {
    recommends 'GraphViz'; # For generating the schema graph
};
