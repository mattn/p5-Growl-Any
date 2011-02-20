package Growl::Any::MacGrowl;

use strict;
use warnings;
use parent qw(Growl::Any::Base);

use Carp       ();
use Mac::Growl ();

sub register {
    my ($self, $appname, $events) = @_;
    $self->SUPER::register($appname, $events);
    my @e = $self->encode_list(@{$events});
    Mac::Growl::RegisterNotifications($self->appname, [ @e, 'Error'], \@e);
}

sub notify {
    my ($self, $event, $title, $message, $icon) = @_;
    if (defined $icon) {
        $icon = $self->icon_file($icon);
    }
    Mac::Growl::PostNotification($self->appname,
        $self->encode_list( $event, $title, $message ), 0, 0, $icon);
}

1;
__END__

=head1 NAME

Growl::Any::MacGrowl - Backend to Mac::Growl

=head1 SYNOPSIS

  use Growl::Any::MacGrowl;
  use Growl::Any;

=head1 DESCRIPTION

This is a Growl::Any backend to Mac::Growl.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

L<Growl::Any>

L<Mac::Growl>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
