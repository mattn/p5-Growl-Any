package Growl::Any::NetGrowl;

use strict;
use warnings;
use parent qw(Net::Growl::Base);

use Carp       ();
use Net::Growl ();

sub register {
    my ($self, $appname, $events) = @_;
    $self->SUPER::register($appname, $events);
    Net::Growl::register(
        host        => 'localhost',
        application => $self->appname,
        password    => $self->{password},
    );
}

sub notify {
    my ($self, $event, $title, $message, $icon) = @_;
    Net::Growl::notify(
         application => $self->appname,
         title       => $self->encode($title),
         description => $self->encode($message),
         password    => $self->{password},
    );
}

1;

__END__

=head1 NAME

Growl::Any::NetGrowl - Backend to Net::Growl

=head1 SYNOPSIS

  use Growl::Any::NetGrowl;

=head1 DESCRIPTION

This is a Growl::Any backend to Net::Growl.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

L<Growl::Any>

L<Net::Growl>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
