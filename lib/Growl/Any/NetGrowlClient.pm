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

Growl::Any::NetGrowlClient - Backend to Net::GrowlClient

=head1 SYNOPSIS

  use Growl::Any;

=head1 DESCRIPTION

This is a Growl::Any backend to Net::GrowlClient.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

L<Growl::Any>

L<Net::GrowlClient>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
