use 5.005;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'DateObj',
    'VERSION_FROM'	=> 'lib/Date/Object/Date.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (#ABSTRACT_FROM => 'Bar.pm', # retrieve abstract from module
	   ABSTRACT   => 'DateObj, a collection of mathemagical date and time objects.', 
       AUTHOR     => 'Matt Luker <kostya@redstarhackers.com>') : ()),
);
