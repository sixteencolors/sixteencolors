use strict;
use warnings;
use Test::More;


use Catalyst::Test 'SixteenColors';
use SixteenColors::Controller::Group;

ok( request('/group')->is_success, 'Request should succeed' );
done_testing();
