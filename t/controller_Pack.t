use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'SixteenColors' }
BEGIN { use_ok 'SixteenColors::Controller::Pack' }

ok( request('/pack')->is_success, 'Request should succeed' );


