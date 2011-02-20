use strict;
use Test::More tests => 1;

BEGIN { use_ok 'Growl::Any' }

diag( Growl::Any->backend );
