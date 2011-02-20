package Growl::Any::GrowlGNTP;

use strict;
use warnings;
use parent qw(Growl::Any::Base);

use Carp        ();
use Growl::GNTP ();

sub register {
    my ($self, $appname, $events) = @_;
    $self->SUPER::register($appname, $events);

    $self->{instance} = Growl::GNTP->new(
        AppName => $self->appname,
    );

    my @e = ();
    push @e, { Name => $self->encode($_) } for @$events;
    push @e, { Name => 'Error' };
    $self->{instance}->register(\@e);
}

sub notify {
    my ($self, $event, $title, $message, $icon) = @_;
    $self->{instance}->notify(
        Title   => $self->encode($title),
        Message => $self->encode($message),
        Event   => $self->encode($event),
        Icon    => $self->encode($icon),
    );
}

1;
__END__

=head1 NAME

Growl::Any::GrowlGNTP - Backend to Growl::GNTP

=head1 SYNOPSIS

  use Growl::Any;

=head1 DESCRIPTION

Growl::Any is perl module that can provide any growl application.
This can notify to desktop application working in local system.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

tokuhirom

=head1 SEE ALSO

L<Growl::Any>

L<notify-send(1)>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
