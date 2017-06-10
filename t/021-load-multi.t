#!/usr/bin/env perl6

use v6;

use Test;

plan 5;

use YAML;

my $yaml = q:to/./;
    doc1: a
    ...
    ---
    doc2: b
    ---
    doc3: c
    .

my $docs = yaml.all.load($yaml);

cmp-ok($docs.elems, '==', 3, "three documents");
cmp-ok($docs[0]<doc1>, 'eq', 'a', "key/value == doc1: a");
cmp-ok($docs[1]<doc2>, 'eq', 'b', "key/value == doc2: b");
cmp-ok($docs[2]<doc3>, 'eq', 'c', "key/value == doc3: c");

my $doc = yaml.single.load($yaml);

cmp-ok($doc<doc1>, 'eq', 'a', "only 1 document");

done-testing;
