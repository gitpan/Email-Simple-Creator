use ExtUtils::MakeMaker;

WriteMakefile (
               AUTHOR        => 'Casey West <casey@geeknest.com>',
               ABSTRACT      => "Email::Simple constructor for starting anew.",
               NAME          => 'Email::Simple::Creator',
               PREREQ_PM     => {
                                 'Test::More'        => '',
                                 'Email::Simple'     => '',
                                 'Time::Local'       => '',
                                },
               VERSION_FROM  => 'lib/Email/Simple/Creator.pm',
              );
