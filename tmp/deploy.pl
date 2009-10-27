#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';

use SixteenColors;

SixteenColors->model( 'DB' )->schema->deploy;
