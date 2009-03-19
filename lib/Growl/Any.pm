package Growl::Any;

use strict;
use warnings;
our $VERSION = '0.01';

sub new {
    my $class = shift;
    bless({ instance => undef }, $class);
}

sub register {}
sub notify {}

no warnings 'redefine';
if (eval { require Mac::Growl; }) {
    *Growl::Any::register = sub {
        my ($self, $appname, $events) = @_;
        Mac::Growl::RegisterNotifications($appname, [ @$events, 'Error' ], $events);
    };
    *Growl::Any::notify = sub {
        my ($self, $appname, $event, $title, $message, $icon) = @_;
        Mac::Growl::PostNotification($appname, $event, $title, $message, 0, 0, $icon);
    };
} elsif (eval { require Desktop::Notify; }) {
    *Growl::Any::register = sub {
        my ($self, $appname, $events) = @_;
        $self->{instance} = Desktop::Notify->new(("app_name" => $appname));
    };
    *Growl::Any::notify = sub {
        my ($self, $appname, $event, $title, $message, $icon) = @_;
        $self->{instance}->create(body => $message, summary => $title, app_icon => $icon);
    };
} elsif (eval { require Net::GrowlClient1; }) {
    *Growl::Any::register = sub {
        my ($self, $appname, $events) = @_;
        push @$events, 'Error';
        $self->{instance} = Net::GrowlClient->init(
            CLIENT_TYPE_REGISTRATION => 0,
            CLIENT_TYPE_NOTIFICATION => 1,
            CLIENT_PASSWORD => '',
            CLIENT_APPLICATION_NAME => $appname,
            CLIENT_NOTIFICATION_LIST => $events
        );
    };
    *Growl::Any::notify = sub {
        my ($self, $appname, $event, $title, $message, $icon) = @_;
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
#        my ($self, $appname, $event, $title, $message, $icon) = @_;
#        my $req = $self->{instance}->Speak("[$event]$title"."\n".$message);
#        my $i = 0;
#		while (($req->Status == 2) || ($req->Status == 4)) {
#		    $self->{instance}->Stop($req) if $i >10; sleep(1);  $i++;
#		}
#    };
}

1;

__END__

=head1 NAME

Growl::Any -

=head1 SYNOPSIS

  use Growl::Any;

=head1 DESCRIPTION

Growl::Any is

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
