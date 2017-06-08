use v6;

use Test;

plan 3;

use YAML;

my $map = %( a => "b" );
my $seq = < item1 item2 >;
my %doc1 = %(
    map => $map,
    map-alias => $map,
    seq => $seq,
    seq-alias => $seq,
);
my $yaml1 = q:to/./;
    ---
    map: &1
      a: b
    map-alias: *1
    seq: &2
    - item1
    - item2
    seq-alias: *2
    ...
    .


my $c = %( id => "C", link => Any );
my $b = %( id => "B", link => $c );
my $a = %( id => "A", link => $b );
$c<link> = $a;
my @doc2 = (
    $a, $b, $c
);
my $yaml2 = q:to/./;
    ---
    - &1
      id: A
      link: &2
        id: B
        link: &3
          id: C
          link: *1
    - *2
    - *3
    ...
    .


my %doc3 = %(
    link => Any;
);
%doc3<link> = %doc3;
my $yaml3 = q:to/./;
    --- &1
    link: *1
    ...
    .

my @tests = (
    %( doc => %doc1, yaml => $yaml1, name => "aliases", ),
    %( doc => @doc2, yaml => $yaml2, name => "circular", ),
    %( doc => %doc3, yaml => $yaml3, name => "circular toplevel", ),
);

for @tests -> $test {
    my $name = $test<name>;
    my $expected-yaml = $test<yaml>;
    my $doc = $test<doc>;

    my $yaml = yaml.dump($doc);

    # diag $yaml;

    cmp-ok($yaml, 'eq', $expected-yaml, "dump works - $name");
}
