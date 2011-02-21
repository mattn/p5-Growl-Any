package Growl::Any::Null;

use strict;
use warnings;
use parent qw(Growl::Any::Base);

sub notify { }

1;

__END__

=head1 NAME

Growl::Any::Null - Null notification

=head1 SYNOPSIS

  use Growl::Any::Null;
  use Growl::Any;

=head1 DESCRIPTION

Growl::Any::Null is used if no backends are available.

=head1 AUTHOR

Yasuhiro Matsumoto E<lt>mattn.jp@gmail.comE<gt>

=head1 SEE ALSO

L<Growl::Any>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
