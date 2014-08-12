requires 'DBIx::Class';
requires 'DBIx::Class::TimeStamp';
requires 'DBIx::Class::Tree::NestedSet';
requires 'Text::CleanFragment';
requires 'JSON::XS';
requires 'Archive::Extract::Libarchive';
requires 'Try::Tiny';
requires 'Directory::Scratch';
requires 'Path::Class';
requires 'File::Basename';
requires 'Image::TextMode';

recommends 'SQL::Translator'; # To deploy the schema

on 'develop'=> sub {
    recommends 'GraphViz'; # For generating the schema graph
};
