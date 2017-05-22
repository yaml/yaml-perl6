use v6;

use Test;

plan 1;

use YAML;

my $api = yaml();
isa-ok($api, "YAML::API");

done-testing;
