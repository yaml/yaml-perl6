use v6;

use Test;

plan 1;

use YAML;

my %doc1 = %(
    foo => 23,
);
my @doc2 = (
    <a b c >
);
my @docs = (%doc1, @doc2);

my $yaml = yaml.dump(@docs);

diag $yaml;

like($yaml, rx/foo/, "dump works");
