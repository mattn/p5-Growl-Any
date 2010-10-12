package Growl::Any;

use strict;
use warnings;
use Carp ();
use Encode;
use LWP::UserAgent;
use File::Temp qw/ :mktemp /;
use File::Which qw/ which /;
use String::ShellQuote qw/ shell_quote /;
our $VERSION = '0.01';

sub new {
    my $class = shift;
    bless({ instance => undef, name => undef }, $class);
}

sub register {}
sub notify {}

no warnings 'redefine';
if (eval { require Mac::Growl; }) {
    *Growl::Any::register = sub {
        my ($self, $appname, $events) = @_;
        Carp::croak 'this is instance method' unless ref $self;
        Carp::croak 'events should be arrayref' unless ref $events eq 'ARRAY';
        Encode::encode('utf8', $appname);
        $self->{name} = $appname;
        $self->{ua} = LWP::UserAgent->new;
        $self->{ua}->env_proxy;
        Mac::Growl::RegisterNotifications($appname, [ @$events, 'Error' ], $events);
    };
    *Growl::Any::notify = sub {
        my ($self, $event, $title, $message, $icon) = @_;
        Carp::croak 'this is instance method' unless ref $self;
        Encode::encode('utf8', $event);
        Encode::encode('utf8', $title);
        Encode::encode('utf8', $message);
        Encode::encode('utf8', $icon);
        if ($icon) {
            my $f = mktemp( "/tmp/XXXXX" );
            $self->{ua}->mirror( $icon, $f );
            $icon = $f;
        }
        Mac::Growl::PostNotification($self->{name}, $event, $title, $message, 0, 0, $icon);
        unlink $icon if defined $icon && -e $icon;
    };
} elsif (which('notify-send')) {
    *Growl::Any::register = sub {
        my ($self, $appname, $events) = @_;
        $self->{ua} = LWP::UserAgent->new;
        $self->{ua}->env_proxy;
    };
    *Growl::Any::notify = sub {
        my ($self, $event, $title, $message, $icon) = @_;
        if ($icon) {
            my $f = mktemp( "/tmp/XXXXX" );
            $self->{ua}->mirror( $icon, $f );
            $icon = $f;
        }
        my $command = shell_quote ('notify-send', '--icon', $icon, $title, $message);
        system($^O eq 'MSWin32' ? "$command 2> NUL" : "$command 2> /dev/null");
        unlink $icon if defined $icon && -e $icon;
    };
} elsif (eval { require Desktop::Notify; }) {
    *Growl::Any::register = sub {
        my ($self, $appname, $events) = @_;
        $self->{name} = encode_utf8($appname);
        $self->{instance} = Desktop::Notify->new(("app_name" => encode_utf8($appname)));
        $self->{ua} = LWP::UserAgent->new;
        $self->{ua}->env_proxy;
    };
    *Growl::Any::notify = sub {
        my ($self, $event, $title, $message, $icon) = @_;
        if ($icon) {
            my $f = mktemp( "/tmp/XXXXX" );
            $self->{ua}->mirror( $icon, $f );
            $icon = $f;
        }
        my $notify = $self->{instance}->create(
            body => encode_utf8($message),
            summary => encode_utf8($title),
            app_icon => encode_utf8($icon),
            timeout => 5000);
        $notify->show;
        unlink $icon if defined $icon && -e $icon;
    };
} elsif (eval { require Growl::GNTP; }) {
    *Growl::Any::register = sub {
        my ($self, $appname, $events) = @_;
        push @$events, 'Error';
        $self->{name} = encode_utf8($appname);
        $self->{instance} = Growl::GNTP->new(
            AppName => encode_utf8($appname),
        );
        my @e = ();
        push @e, { Name => encode_utf8($_) } for @$events;
        $self->{instance}->register(\@e);
    };
    *Growl::Any::notify = sub {
        my ($self, $event, $title, $message, $icon) = @_;
        $self->{instance}->notify(
            Title => encode_utf8($title),
            Message => encode_utf8($message),
            Event => encode_utf8($event),
            Icon => encode_utf8($icon));
    };
} elsif (eval { require Net::GrowlClient; }) {
    *Growl::Any::register = sub {
        my ($self, $appname, $events) = @_;
        push @$events, 'Error';
        $self->{name} = $appname;
        $self->{instance} = Net::GrowlClient->init(
            CLIENT_TYPE_REGISTRATION => 0,
            CLIENT_TYPE_NOTIFICATION => 1,
            CLIENT_PASSWORD => '',
            CLIENT_APPLICATION_NAME => $appname,
            CLIENT_NOTIFICATION_LIST => $events
        );
    };
    *Growl::Any::notify = sub {
        my ($self, $event, $title, $message, $icon) = @_;
        $self->{instance}->notify(
            title => $title,
            message => $message,
            notification => $event);
    };
# TODO: MSAgent does not work correctly.
#} elsif (eval { require Win32::OLE; require Win32::MSAgent; }) {
#    *Growl::Any::register = sub {
#        my ($self, $appname, $events) = @_;
#        my $character = 'Merlin';
#        my $agent = Win32::MSAgent->new($character);
#        $agent->Language2LanguageID("English (United States)"); 
#        $self->{instance} = $agent->Characters($character);
#        $self->{instance}->SoundEffectsOn(1);
#        $self->{instance}->Show();
#    };
#    *Growl::Any::notify = sub {
#        my ($self, $event, $title, $message, $icon) = @_;
#        my $req = $self->{instance}->Speak("[$event]$title"."\n".$message);
#        my $i = 0;
#        while (($req->Status == 2) || ($req->Status == 4)) {
#            $self->{instance}->Stop($req) if $i >10; sleep(1);  $i++;
#        }
#    };
} else {
    die "You don't have any Growl like module!";
}

1;

__END__

=head1 NAME

Growl::Any -

=head1 SYNOPSIS

  use Growl::Any;
  my $growl = Growl::Any->new;
  $growl->register("my app", ['Test1', 'Test2']);
  $growl->notify("Test1", "foo", "bar");

=head1 DESCRIPTION

Growl::Any is perl module that can provide any growl application.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

tokuhirom

=head1 SEE ALSO

L<Mac::Growl>, L<Desktop::Notify>, L<Net::GrowlClient>, L<Win32::MSAgent>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
