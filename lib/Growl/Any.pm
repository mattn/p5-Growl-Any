package Growl::Any;

use strict;
use warnings;
use Carp ();
use Encode;
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
        $self->{name} = $appname;
        Mac::Growl::RegisterNotifications($appname, [ @$events, 'Error' ], $events);
    };
    *Growl::Any::notify = sub {
        my ($self, $event, $title, $message, $icon) = @_;
        Carp::croak 'this is instance method' unless ref $self;
        Mac::Growl::PostNotification($self->{name}, $event, $title, $message, 0, 0, $icon);
    };
} elsif (eval { require Desktop::Notify; }) {
    *Growl::Any::register = sub {
        my ($self, $appname, $events) = @_;
        $self->{name} = $appname;
        $self->{instance} = Desktop::Notify->new(("app_name" => $appname));
    };
    *Growl::Any::notify = sub {
        my ($self, $event, $title, $message, $icon) = @_;
        $self->{instance}->create(body => $message, summary => $title, app_icon => $icon);
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
            title => decode_utf8($title),
            message => decode_utf8($message),
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
