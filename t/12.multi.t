use v6;

use Test;

plan 1;

use YAML;

my $api = yaml();
my $yaml = q:to/END/;
doc1: a
...
---
doc2: b
---
doc3: c
END
my $docs = $api.load($yaml);
say $docs;

cmp-ok($docs.elems, '==', 3, "three documents");

done-testing;
