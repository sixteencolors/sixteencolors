#!/usr/bin/env perl

use warnings;
use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use SQL::Translator;
use SixteenColors::Schema;

my $sqlt = SQL::Translator->new(
    parser        => 'SQL::Translator::Parser::DBIx::Class',
    producer      => 'GraphViz',
    producer_args => {
        layout => 'dot',    # dot neato twopi
        # width => 8.5, height => 11,
        width            => 0,
        height           => 0,
        fontsize         => 10,
        show_constraints => 1,
        show_datatypes   => 1,
        show_sizes       => 1,
        show_indexes     => 1,
        bgcolor          => 'lightgoldenrodyellow',
        overlap          => 'false',
        out_file         => "$FindBin::Bin/../etc/schema.png",
    },
    data => 'SixteenColors::Schema'
);

$sqlt->translate or die $sqlt->error;
