use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'SixteenColors' }
BEGIN { use_ok 'SixteenColors::Controller::Authenticate' }

ok( request('/authenticate')->is_success, 'Request should succeed' );


