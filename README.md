# NAME

Growl::Any - Common interface to Growl

# SYNOPSIS

    use Growl::Any;
    my $growl = Growl::Any->new(appname => "my app", events => ["event1", "event2"]);
    $growl->notify("event1", "title", "message", "path/to/icon");

# DESCRIPTION

Growl::Any is a Perl module that provide growls using growl modules.
This can notify to desktop applications working in the local system.

# INTERFACE

## `Growl::Any->new(appname => $appname, events => $events, ...)`

Creates a Growl::Any client with _$appname_ and _$events_.

_$appname_ must be a text string, and _$events_ must be an ARRAY reference
consisting of text strings.

## `$growl->notify($event, $title, $message, $path\_to\_icon\_file)`

Show a notification with given arguments.

## `Growl::Any->backend`

Returns the Growl::Any backend.

# AUTHOR

Yasuhiro Matsumoto <mattn.jp@gmail.com>

tokuhirom

# SEE ALSO

[Mac::Growl](http://search.cpan.org/perldoc?Mac::Growl), [Desktop::Notify](http://search.cpan.org/perldoc?Desktop::Notify), [Net::GrowlClient](http://search.cpan.org/perldoc?Net::GrowlClient), [Net::Growl](http://search.cpan.org/perldoc?Net::Growl)

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
