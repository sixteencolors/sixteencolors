use strict;
use warnings;
use Test::More;


use Catalyst::Test 'SixteenColors';
use SixteenColors::Controller::Pack;

ok( request('/pack')->is_success, 'Request should succeed' );
done_testing();
