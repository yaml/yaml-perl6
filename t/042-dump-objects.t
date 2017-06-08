use v6;

use Test;

plan 1;

use YAML;

class YAML::Test::Example {
    has $!x;
    has $.y;
    has $.hash;
    submethod BUILD(:$!x, :$!y, :$!hash) {}
}

my %hash = %( a => "b" );
my $obj = YAML::Test::Example.new( x => "x", y => "Y", hash => %hash );

my %doc1 = %(
    object => $obj,
    hash => %hash,
    object-alias => $obj,
);
my $yaml1 = q:to/./;
    ---
    hash: &1
      a: b
    object: &2
      hash: *1
      x: x
      y: Y
    object-alias: *2
    ...
    .

my @tests = (
    %( doc => %doc1, yaml => $yaml1, name => "objects", ),
);

for @tests -> $test {
    my $name = $test<name>;
    my $expected-yaml = $test<yaml>;
    my $doc = $test<doc>;

    my $yaml = yaml.dump($doc);

    # diag $yaml;

    cmp-ok($yaml, 'eq', $expected-yaml, "dump works - $name");
}
