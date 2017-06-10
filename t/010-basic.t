use v6;

use Test;

plan 6;

use YAML;

my $api = yaml();
isa-ok($api, "YAML::API");

my $set = $api.all(Bool);
is($set, False, "yaml()");

my $api-all = yaml.all;
$set = $api-all.all(Bool);
is($set, True, "\$api.all(True)");

$api-all.all(False);
$set = $api-all.all(Bool);
is($set, False, "\$api.all(False)");


$api.single(True);
$set = $api.single(Bool);
is($set, True, "\$api.single(True)");

$api.single(False);
$set = $api.single(Bool);
is($set, False, "\$api.single(False)");



done-testing;
