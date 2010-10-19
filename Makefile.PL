use inc::Module::Install;
name 'Growl-Any';
all_from 'lib/Growl/Any.pm';

# requires '';
requires 'String::ShellQuote';
requires 'Net::Growl';
requires 'File::Which';
requires 'LWP::UserAgent';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
