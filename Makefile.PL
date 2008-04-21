use inc::Module::Install;
name 'Data-Storage';
all_from 'lib/Data/Storage.pm';
perl_version '5.006';

requires 'Class::Accessor::Complex';
requires 'Class::Accessor::Constructor';
requires 'Class::Null';
requires 'Data::Miscellany';
requires 'DBI';
requires 'Error::Hierarchy';

build_requires 'Test::More' => '0.70';

use_standard_tests(without => 'pod_coverage');
auto_include;
WriteAll;
