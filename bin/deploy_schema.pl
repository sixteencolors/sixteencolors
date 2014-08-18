#!/usr/bin/env perl

use warnings;
use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";
use SixteenColors;

my $schema = SixteenColors->model( 'DB' )->schema;
$schema->deploy;
