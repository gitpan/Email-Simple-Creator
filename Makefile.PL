use strict;
use ExtUtils::MakeMaker;

WriteMakefile (
  AUTHOR        => 'Ricardo SIGNES <rjbs@cpan.org>',
  ABSTRACT      => "Email::Simple constructor for starting anew.",
  NAME          => 'Email::Simple::Creator',
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM     => {
    'Test::More'          => '0.47',
    'Email::Simple'       => '2.003',
    'Email::Date::Format' => '1.000', # first release
  },
  VERSION_FROM  => 'lib/Email/Simple/Creator.pm',
);
