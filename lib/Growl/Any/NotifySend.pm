package Growl::Any::NotifySend;
use strict;
use warnings;
use parent qw(Growl::Any::Base);

use Carp        ();
use File::Which ();

our $COMMAND = File::Which::which('notify-send')
    || Carp::croak("Command not found: notify-send");

sub notify {
    my ($self, $event, $title, $message, $icon) = @_;

    my @opts;
    if(defined $icon) {
        push @opts, '--icon', $self->icon_file($icon);
    }

    system(
        $COMMAND,
        $self->encode_list($title, $message),
        @opts,
    );
}

1;
__END__

=head1 NAME

Growl::Any::NotifySend - Backend to notify-send(1)

=head1 SYNOPSIS

  use Growl::Any::NotifySend;
  use Growl::Any;

=head1 DESCRIPTION

This is a Growl::Any backend to C<notify-send(1)>.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

L<Growl::Any>

L<notify-send(1)>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
