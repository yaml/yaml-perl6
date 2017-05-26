use v6;

use Test;

plan 2;

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

cmp-ok($docs.elems, '==', 3, "three documents");

# testing if loader resets
$docs = $api.load($yaml);
cmp-ok($docs.elems, '==', 3, "again three documents");

done-testing;
