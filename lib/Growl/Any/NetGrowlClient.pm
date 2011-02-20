package Growl::Any::NetGrowlClient;

use strict;
use warnings;
use parent qw(Growl::Any::Base);

use Carp             ();
use Net::GrowlClient ();

sub register {
    my ($self, $appname, $events) = @_;
    $self->set_appname($appname);

    $self->{instance} = Net::GrowlClient->init(
        CLIENT_TYPE_REGISTRATION => 0,
        CLIENT_TYPE_NOTIFICATION => 1,
        CLIENT_PASSWORD          => $self->{password},
        CLIENT_APPLICATION_NAME  => $self->appname,
        CLIENT_NOTIFICATION_LIST => [ $self->encode_list(@{$events}), 'Error'],
    );
};

sub notify {
    my ($self, $event, $title, $message, $icon) = @_;
    $self->{instance}->notify(
        title        => $self->encode($title),
        message      => $self->encode($message),
        notification => $self->encode($event),
    );
}

1;
__END__

=head1 NAME

Growl::Any - Common interface to Growl

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
