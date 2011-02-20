#!perl -w

use strict;
use Test::More tests => 1;

use Growl::Any;

my $g = Growl::Any->new(
    appname => 'growl-any',
    events  => ['foo', 'bar'],
);

$g->notify('foo', 'title1', 'message1');
$g->notify('bar', 'title2', 'message2');

pass;
