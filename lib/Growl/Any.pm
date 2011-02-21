package Growl::Any;

use 5.008_001;
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

        Null
        IOHandle
    );

    foreach my $b(@backends) {
        my $file = "Growl/Any/$b.pm";
        print STDERR "try to load $file ... " if _DEBUG;
        if(eval { require $file }) {
            $backend = $file;
            print STDERR "ok.\n" if _DEBUG;
            last;
        }
        else {
            print STDERR "not ok.\n" if _DEBUG;
        }
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

Growl::Any is a Perl module that provide growls using growl modules.
This can notify to desktop applications working in the local system.

=head1 INTERFACE

=head2 C<< Growl::Any->new(appname => $appname, events => $events, ...) >>

Creates a Growl::Any client with I<$appname> and I<$events>.

I<$appname> must be a text string, and I<$events> must be an ARRAY reference
consisting of text strings.

=head2 C<< $growl->notify($event, $title, $message, $path_to_icon_file) >>

Show a notification with given arguments.

=head2 C<< Growl::Any->backend >>

Returns the Growl::Any backend.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

tokuhirom

=head1 SEE ALSO

L<Mac::Growl>, L<Desktop::Notify>, L<Net::GrowlClient>, L<Net::Growl>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
