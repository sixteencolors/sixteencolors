use strict;
use warnings;

use SixteenColors;

my $app = SixteenColors->apply_default_middlewares(SixteenColors->psgi_app);
$app;

