use strict;
use warnings;
use utf8;
use Growl::Any;

my $g = Growl::Any->new;
$g->register('mattn', ['sleep']);
$g->notify('sleep', 'mattn as TKSK', 'ZIGOROu の説教まじはんぱねえ', 'http://st-hatena.com/users/to/tokuhirom/profile.gif');

