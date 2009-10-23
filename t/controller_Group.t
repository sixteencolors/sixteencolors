use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'SixteenColors' }
BEGIN { use_ok 'SixteenColors::Controller::Group' }

ok( request('/group')->is_success, 'Request should succeed' );


