package Growl::Any;

use strict;
use warnings;
use constant _DEBUG => $ENV{GROWL_ANY_DEBUG} ? 1 : 0;

our $VERSION = '0.04';

my $backend;

# already loaded?
foreach my $module(keys %INC) {
    if($module =~ m{\A Growl/Any/ }xms && $module !~ m{ /Base.pm \z}xms) {
        $backend = $module;

        print STDERR "$backend loaded.\n" if _DEBUG;
    }
}

# try to find the backend
if(!$backend) {
    my @backends = qw(
        MacGrowl
        CocoaGrowl
        NotifySend
        DesktopNotify
        GrowlGNTP
        NetGrowlClient
        NetGrowl
        Win32MSAgent

        IOHandle
    );

    foreach my $b(@backends) {
        my $file = "Growl/Any/$b.pm";
        if(eval { require $file }) {
            $backend = $file;
            last;
        }
        print STDERR "try to load $file ... ", ($@ ? "not " : ""), "ok.\n"
            if _DEBUG;
    }
}

$backend =~ s{/}{::}xmsg;
$backend =~ s/\.pm \z//xms;

our @ISA = ($backend);

sub backend { $backend }

1;
__END__

=head1 NAME

Growl::Any - Common interface to Growl

=head1 SYNOPSIS

  use Growl::Any;
  my $growl = Growl::Any->new("my app", ["event1", "event2"]);
  $growl->notify("event1", "title", "message", "path/to/icon");

=head1 DESCRIPTION

Growl::Any is perl module that can provide any growl application.
This can notify to desktop application working in local system.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

tokuhirom

=head1 SEE ALSO

L<Mac::Growl>, L<Desktop::Notify>, L<Net::GrowlClient>, L<Net::Growl>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
