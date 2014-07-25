requires 'DBIx::Class';
requires 'DBIx::Class::TimeStamp';
requires 'Text::CleanFragment';
requires 'JSON::XS';

on 'develop'=> sub {
    recommends 'SQL::Translator';
    recommends 'GraphViz';
};
