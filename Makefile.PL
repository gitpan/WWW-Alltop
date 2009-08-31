
use inc::Module::Install;

name 'WWW-Alltop';
all_from 'lib/WWW/Alltop.pm';

requires 'Moose';
requires 'DateTime';
requires 'Log::Log4perl';
requires 'WWW::Mechanize';
requires 'HTML::TokeParser';
requires 'XML::OPML';

install_script glob('script/*');
auto_install;
WriteAll;
