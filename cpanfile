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
requires 'Class::Load';
requires 'Catalyst::Runtime';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Config::General';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::View::TT::Alloy';
requires 'Catalyst::Action::RenderView';

recommends 'SQL::Translator'; # To deploy the schema

on 'develop'=> sub {
    requires 'Catalyst::Devel';
    recommends 'GraphViz'; # For generating the schema graph
};
