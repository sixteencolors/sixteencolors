use strict;
use warnings;

use SixteenColors::API;

my $app = SixteenColors::API->apply_default_middlewares(SixteenColors::API->psgi_app);
$app;

