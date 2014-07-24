requires 'DBIx::Class';
requires 'DBIx::Class::TimeStamp';
requires 'Text::CleanFragment';

on 'develop'=> sub {
    recommends 'SQL::Translator';
    recommends 'GraphViz';
};
