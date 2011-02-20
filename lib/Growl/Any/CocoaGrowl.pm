package Growl::Any::CocoaGrowl;

use strict;
use warnings;
use parent qw(Growl::Any::Base);

use Carp         ();
use Cocoa::Growl ();

sub register {
    my ($self, $appname, $events) = @_;
    $self->SUPER::register($appname, $events);
    Cocoa::Growl::growl_register(
        app           => $self->appname,
        notifications => [ $self->encode_list(@{$events}) ],
    );
}

sub notify {
    my ($self, $event, $title, $message, $icon) = @_;
    Cocoa::Growl::growl_notify(
        name         => $self->encode($event),
        title        => $self->encode($title),
        description  => $self->encode($message),
        icon         => $icon,
    );
}

1;
__END__

=head1 NAME

Growl::Any::CocoaGrowl - Backend to Cocoa::Growl

=head1 SYNOPSIS

  use Growl::Any;

=head1 DESCRIPTION

This is a Growl::Any backend to Cocoa::Growl.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

L<Growl::Any>

L<Cocoa::Growl>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
