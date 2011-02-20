package Growl::Any::Base;
use strict;
use warnings;

use Carp       ();
use Encode     ();
use File::Temp ();

sub new {
    my $class = shift;
    my %args  = ( @_ == 1 ? %{$_[0]} : @_);

    my $self  = bless \%args, $class;

    $self->{encoding} = Encode::find_encoding( $args{encoding} || 'UTF-8' )
        || Carp::croak("Unknown encoding '$args{encoding}'");

    $self->register($args{appname}, $args{events})
        if $args{appname} or $args{events};

    return $self;
}

sub appname {
    my($self) = @_;
    return $self->{appname};
}

sub register {
    my($self, $appname, $events) = @_;
    Carp::croak("register() is an instance method") if not ref $self;
    Carp::croak("You must define an app name")      if not defined $appname;
    Carp::croak("You must pass events")             if ref($events) ne 'ARRAY';
    $self->{appname} = $self->encode($appname);
}

sub notify; # abstract method

sub encode {
    my($self, $text_str) = @_;
    return defined($text_str)
        ? $self->{encoding}->encode($text_str)
        : $text_str;
}

sub encode_list {
    my $self = shift;
    return map { defined($_) ? $self->{encoding}->encode($_) : $_ } @_;
}

sub _tmpfile { # returns a filehandle with filename() method
    my($self) = @_;
    require File::Temp;
    return File::Temp->new();
}

sub _ua {
    my($self) = @_;
    return $self->{ua} ||= do {
        require LWP;
        require LWP::UserAgent;
        my $ua = LWP::UserAgent->new( agent =>
            sprintf 'Growl::Any (LWP/%s)', LWP->VERSION );
        $ua->env_proxy();
        return $ua;
    };
}

sub icon_file {
    my($self, $icon) = @_;
    unless(-e $icon) { # seems URI
        my $tmpfile = $self->_tmpfile();
        $self->_ua->mirror( $icon, $tmpfile );
        return  $tmpfile;
    }
    return $icon;
}

1;
__END__

=head1 NAME

Growl::Any::Base - The base class for Growl::Any implementations

=head1 SYNOPSIS

  package Growl::Any::MyImplementation;
  use parent qw(Growl::Any::Base);

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
