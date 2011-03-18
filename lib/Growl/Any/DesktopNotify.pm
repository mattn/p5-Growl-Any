package Growl::Any::DesktopNotify;
use strict;
use warnings;
use parent qw(Growl::Any::Base);

use Carp            ();
use Desktop::Notify ();

sub register {
    my ($self, $appname, $events) = @_;
    $self->SUPER::register($appname, $events);
    $self->{instance} = Desktop::Notify->new(
        "app_name" => $self->appname,
    );
}

sub notify {
    my ($self, $event, $title, $message, $icon) = @_;
    $icon = $self->icon_file($icon) if defined $icon;
    my $notify = $self->{instance}->create(
        body     => $self->encode($message),
        summary  => $self->encode($title),
        timeout  => 5000,
        app_icon => $icon,
    );
    $notify->show();
}

1;
__END__

=head1 NAME

Growl::Any::DesktopNotify - Backend to Desktop::Notify

=head1 SYNOPSIS

  use Growl::Any::DesktopNotify;

=head1 DESCRIPTION

This is a Growl::Any backend to DesktopNotify.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

L<Growl::Any>

L<Desktop::Notify>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
