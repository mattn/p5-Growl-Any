use inc::Module::Install;
name 'Growl-Any';
all_from 'lib/Growl/Any.pm';

requires 'LWP::UserAgent';

test_requires 'Test::More';
test_requires 'parent';
test_requires 'IO::Handle';

tests 't/*.t';
author_tests 'xt';

WriteAll;
