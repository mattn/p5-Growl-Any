use inc::Module::Install;
name 'Growl-Any';
all_from 'lib/Growl/Any.pm';

requires 'File::Which';
requires 'LWP::UserAgent';

test_requires 'Test::More';

tests 't/*.t';
author_tests 'xt';

WriteAll;
