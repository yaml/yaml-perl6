use v6;

use Test;

plan 2;

use YAML;

my $api = yaml();
my $yaml = q:to/END/;
foo: 23
seq: &seq
- a
- b
- c
seq-alias: *seq
scalar: &s 42
scalar-alias: *s
END
my %data = $api.load($yaml);
#say %data;
cmp-ok(%data<foo>, '==', 23, "load works");

%data<seq>[0] = "A";
cmp-ok(%data<seq-alias>[0], 'eq', "A", "sequence aliases work");

# TODO
#say %data<scalar>;
#say %data<scalar-alias>;
#cmp-ok(%data<scalar-alias>, '==', 42, "scalar aliases work");

done-testing;
