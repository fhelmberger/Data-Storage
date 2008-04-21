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

build_requires 'Test::More' => '0.70';

process_templates(
    first_year => 2004,
    rest_from  => "$ENV{HOME}/.mitlib/standard_pod",
    start_tag  => '{%',
    end_tag    => '%}',
);

use_standard_tests(without => 'pod_coverage');
auto_install;
auto_include;
WriteAll;
