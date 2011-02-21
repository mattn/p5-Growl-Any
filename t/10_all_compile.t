#!perl  -w
use strict;
use Test::More 'no_plan';

# compiling checks
foreach my $m(qw(
    Mac/Growl.pm
    Cocoa/Growl.pm
    Growl/GNTP.pm
    Win32/MSAgent.pm
    Net/Growl.pm
    Net/GrowlClient.pm
    Desktop/Notify.pm
    Growl/NotifySend.pm
)) {
    $INC{$m} = __FILE__;
    (my $b = $m) =~ s{/}{}g;
    ok eval { require "Growl/Any/$b" }, $b
        or diag $@;
}

