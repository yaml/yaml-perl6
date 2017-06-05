use v6;

use Test;

plan 1;

use YAML;

my %doc1 = %(
    foo => "bar",
    'undef' => Any,
    integer => 23,
    float => 3.14159,
    'true' => True,
    'false' => False,
    doublequotes => 'string"with"quotes',
    singleequotes => "string'with'quotes",
    'looks-like-true' =>'true',
    'empty-string' => '',
);
my @doc2 = (
    <a b c >
);
my @docs = (%doc1, @doc2);

my $yaml = yaml.dump(@docs);

# diag $yaml;

my $expected-yaml = q:to/./;
    ---
    doublequotes: string"with"quotes
    empty-string: ''
    'false': false
    float: 3.14159
    foo: bar
    integer: 23
    looks-like-true: 'true'
    singleequotes: string'with'quotes
    'true': true
    undef: ~
    ...
    ---
    - a
    - b
    - c
    ...
    .

cmp-ok($yaml, 'eq', $expected-yaml, "dump works");
