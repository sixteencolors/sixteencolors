#!/usr/bin/env perl

use warnings;
use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

# TEMP: Update once we have Catalyst to use to load the schema
use SixteenColors::Schema;
my @dsn = ( 'dbi:SQLite:dbname=sixteencolors.db', undef, undef, {}, { quote_names => 1 } ); 
my $schema = SixteenColors::Schema->connect( @dsn );
# /TEMP

$schema->deploy;
