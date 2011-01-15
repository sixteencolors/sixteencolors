use strict;
use warnings;
use Test::More;


use Catalyst::Test 'SixteenColors';
use SixteenColors::Controller::Search;

ok( request('/search')->is_success, 'Request should succeed' );
done_testing();
