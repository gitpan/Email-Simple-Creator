package Email::Simple::Creator;
# $Id: Creator.pm,v 1.1 2004/06/17 18:44:48 cwest Exp $
use strict;

use vars qw[$VERSION $CRLF];
$VERSION = (qw$Revision: 1.1 $)[1];
$CRLF    = "\x0a\x0d";

sub _date_header {
    my ($sec, $min, $hour, $mday, $mon, $year, $wday) = (gmtime)[0..6];
    my $day   = (qw[Sun Mon Tue Wed Thu Fri Sat])[$wday];
    my $month = (qw[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec])[$mon];
    $year += 1900;
    sprintf "%s, %d %s %d %02d:%02d:%02d -0000",
      $day, $mday, $month, $year, $hour, $min, $sec;
}

sub _add_to_header {
    my ($class, $header, $key, $value) = @_;
    ${$header} .= join(": ", $key, $value) . $CRLF;
}

package Email::Simple;
use strict;

use vars qw[$CREATOR];
$CREATOR = 'Email::Simple::Creator';

sub create {
    my ($class, %args) = @_;

    my @headers = @{ $args{header} || [] };
    my $body    = $args{body} || '';
    my $header  = '';
    my %headers;

    pop @headers if @headers % 2 == 1;
    while ( my ($key, $value) = splice @headers, 0, 2 ) {
        $headers{$key} = 1;
        $CREATOR->_add_to_header(\$header, $key, $value);
    }

    $CREATOR->_add_to_header(\$header,
      Date => $CREATOR->_date_header
    ) unless $headers{Date};

    my $CRLF = do { no strict 'refs'; ${"$CREATOR\::CRLF"} };
    $class->new("$header$CRLF$body$CRLF");
}

1;

__END__

=head1 NAME

Email::Simple::Creator - Email::Simple constructor for starting anew.

=head1 SYNOPSIS

  use Email::Simple;
  use Email::Simple::Creator;
  
  my $email = Email::Simple->create(
      header => [
        From    => 'casey@geeknest.com',
        To      => 'drain@example.com',
        Subject => 'Message in a bottle',
      ],
      body => '...',
  );
  
  $email->header_set( 'X-Content-Container' => 'bottle/glass' );
  
  print $email->as_string;

=head1 DESCRIPTION

This software provides a constructor to L<Email::Simple|Email::Simple> for
creating messages from scratch.

=head2 Methods

=over 5

=item create

  my $email = Email::Simple->create(header => [ @headers ], body => '...');

This method is a constructor that creates an C<Email::Simple> object
from a set of named parameters. The C<header> parameter's value is a
list reference containing a set of headers to be created. The C<body>
parameter's value is a scalar value holding the contents of the message
body.

If no C<Date> header is specified, one will be provided for you based on
the C<gmtime()> of the local machine. This is because the C<Date> field
is a required header and is a pain in the neck to create manually for
every message. The C<From> field is also a required header, but it is
I<not> provided for you.

The parameters passed are used to create an email message that is passed
to C<< Email::Simple->new() >>. C<create()> returns the value returned
by C<new()>. With skill, that's an C<Email::Simple> object.

=back

=head1 SEE ALSO

L<Email::Simple>,
L<perl>.

=head1 AUTHOR

Casey West, <F<casey@geeknest.com>>.

=head1 COPYRIGHT

  Copyright (c) 2004 Casey West.  All rights reserved.
  This module is free software; you can redistribute it and/or modify it
  under the same terms as Perl itself.

=cut
