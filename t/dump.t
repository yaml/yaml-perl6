use v6;
use Test;

use YAML;

plan 4;

is YAML::dump([1, 2, 3]),
'---
- 1
- 2
- 3
...
', 'Dump Simple Array';

is YAML::dump({foo => 1, bar => 2, baz=> 3}),
'---
bar: 2
baz: 3
foo: 1
...
', 'Dump Simple Hash';

is YAML::dump("A string"),
'--- A string
...
', 'Dump a Simple String';

is YAML::dump(123),
'--- 123
...
', 'Dump a Simple Number';
