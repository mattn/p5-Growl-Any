package Growl::Any::Win32MSAgent;

use strict;
use warnings;
use parent qw(Growl::Any::Base);

use Carp           ();
use Win32::MSAgent ();

sub register {
    my ($self, $appname, $events) = @_;
    $self->SUPER::register($appname, $events);

    my $character = 'Merlin';
    my $agent = Win32::MSAgent->new($character);
    $agent->Language2LanguageID("English (United States)");
    $self->{instance} = $agent->Characters($character);
    $self->{instance}->SoundEffectsOn(1);
    $self->{instance}->Show();
}

sub notify {
    my ($self, $event, $title, $message, $icon) = @_;
    my $req = $self->{instance}->Speak("[$event]$title"."\n".$message);
    my $i = 0;
    while (($req->Status == 2) || ($req->Status == 4)) {
        $self->{instance}->Stop($req) if $i >10;
        sleep(1);
        $i++;
    }
}

1;

__END__

=head1 NAME

Growl::Any::Win32MSAgent - Backend to Win32::MSAgent

=head1 SYNOPSIS

  use Growl::Any;

=head1 DESCRIPTION

This is a Growl::Any backend to Win32::MSAgent.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

L<Growl::Any>

L<Win32::MSAgent>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
