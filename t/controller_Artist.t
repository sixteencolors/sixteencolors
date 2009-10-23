use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'SixteenColors' }
BEGIN { use_ok 'SixteenColors::Controller::Artist' }

ok( request('/artist')->is_success, 'Request should succeed' );


