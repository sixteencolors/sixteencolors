use strict;
use warnings;
use Test::More;


use Catalyst::Test 'SixteenColors';
use SixteenColors::Controller::Artist;

ok( request('/artist')->is_success, 'Request should succeed' );
done_testing();
