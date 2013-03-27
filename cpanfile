requires 'LWP::UserAgent';
requires 'perl', '5.008001';

on configure => sub {
    requires 'Module::Build::Tiny';
};

on build => sub {
    requires 'ExtUtils::MakeMaker', '6.59';
    requires 'IO::Handle';
    requires 'Test::More';
    requires 'parent';
};
