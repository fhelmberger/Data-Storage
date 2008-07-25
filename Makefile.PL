use inc::Module::Install;
include 'Module::AutoInstall';

name 'Data-Storage';
all_from 'lib/Data/Storage.pm';
perl_version '5.006';

requires 'Class::Accessor::Complex';
requires 'Class::Accessor::Constructor';
requires 'Class::Null';
requires 'Data::Miscellany';
requires 'DBI';
requires 'Error::Hierarchy';

recommends 'Test::Pod';
recommends 'Test::Pod::Coverage';

test_requires 'Test::More' => '0.70';
test_requires 'Test::Compile';

auto_install;
auto_include;
WriteAll;
