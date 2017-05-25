use v6;

use Test;

plan 11;

use YAML;

my $api = yaml();
my $yaml = q:to/END/;
foo: 23
seq: &seq
- a
- b
- c
seq-alias: *seq
map: &map
  a: 1
  b: 2
map-alias: *map
scalar: &s 42
scalar-alias: *s
null-value: null
true-value: true
false-value: false
integer: 23
float: 3.14159
hex: 0x17
oct: 0o27
END
my $docs = $api.load($yaml);
my %data = $docs[0];
cmp-ok(%data<foo>, '==', 23, "load works");

%data<seq>[0] = "A";
cmp-ok(%data<seq-alias>[0], 'eq', "A", "sequence aliases work");

%data<map><b>++;
cmp-ok(%data<map-alias><b>,'==', 3, "mapping aliases work");

cmp-ok(%data<scalar-alias>, '==', 42, "scalar aliases work");

ok((not defined %data<null-value>), "null");
cmp-ok(%data<true-value>, '==', True, "true");
cmp-ok(%data<false-value>, '==', False, "false");
isa-ok(%data<integer>, "Int", "integer");
isa-ok(%data<float>, "Rat", "float");
cmp-ok(%data<hex>, '==', 23, "hex");
cmp-ok(%data<oct>, '==', 23, "oct");

done-testing;
