#!perl -w

use strict;
use Test::More tests => 1;

use Growl::Any;

my $g = Growl::Any->new(
    appname => 'growl-any',
    events  => ['foo'],
);

$g->notify('foo', 'title', 'message');

pass;
