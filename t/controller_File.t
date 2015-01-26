use strict;
use warnings;
use Test::More;


use Catalyst::Test 'SixteenColors';
use SixteenColors::Controller::File;

ok( request('/file')->is_success, 'Request should succeed' );
done_testing();
