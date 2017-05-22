use v6;

use Test;

plan 1;

use YAML;

my $api = yaml();
my $yaml = "foo: 23";
my %data = $api.load($yaml);
cmp-ok(%data<foo>, '==', 23, "load works");

done-testing;
