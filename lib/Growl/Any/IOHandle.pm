package Growl::Any::IOHandle;

use strict;
use warnings;
use parent qw(Growl::Any::Base);

sub notify {
    my($self, $event, $title, $message, $icon) = @_;

    printf "[%s] %s\n", $title, $message;
}

1;

__END__

=head1 NAME

Growl::Any::IOHandle - Notification to an I/O handle

=head1 SYNOPSIS

  use Growl::Any::IOHandle;

=head1 DESCRIPTION

Growl::Any::Debug is a Growl::Any backend for testing and debugging.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

L<Growl::Any>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
