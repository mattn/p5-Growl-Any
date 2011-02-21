package Growl::Any::NotifySend;
use strict;
use warnings;
use parent qw(Growl::Any::Base);

use Carp              ();
use Growl::NotifySend ();

sub notify {
    my ($self, $event, $title, $message, $icon) = @_;

    my @opts;
    if(defined $icon) {
        push @opts, 'icon', $self->icon_file($icon);
    }

    Growl::NotifySend->show(
        summary => $title,
        body    => $message,
        @opts,
    );
}

1;
__END__

=head1 NAME

Growl::Any::NotifySend - Backend to Growl::NotifySend

=head1 SYNOPSIS

  use Growl::Any::NotifySend;
  use Growl::Any;

=head1 DESCRIPTION

This is a Growl::Any backend to Growl::NotifySend.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

L<Growl::Any>

L<Growl::NotifySend>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
