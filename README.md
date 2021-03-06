# Perl6 YAML

[![Build Status](https://travis-ci.org/yaml/yaml-perl6.svg)](https://travis-ci.org/yaml/yaml-perl6)

A [YAML](https://yaml.org/) Loader and Dumper

# INSTALLATION

Currently this depends on
[LibYAML.pm6](https://github.com/yaml/yaml-libyaml-perl6)

## Install from Sources

You can install this YAML module from source like this:

    $ zef install https://github.com/yaml/yaml-perl6.git
    # or
    $ git clone https://github.com/yaml/yaml-perl6.git
    $ cd yaml-perl6
    $ zef install .

# Examples

The toplevel API is the first thing we want to get stable. The layer under that,
the Loader/Dumper/Reader/Writer/Parser/Emitter will change, so it's not
recommended to use that and think it will always work. Make sure to update
LibYAML also when updating this module.

    # current usage
    use YAML;

    my $yaml = q:to/./
        ---
        integer: 23
        map:
          a: true
          b: false
        sequence:
        - x
        - y
        - z
        ...
        ---
        This is: document no. 2
        ...
        .

    # get back single document
    # note that currently, this will parse the complete string instead
    # of stopping after the first document
    my $doc = yaml.load($yaml);
    my %hash = yaml.load($yaml);

    # load all documents
    my @docs = yaml.all.load($yaml);
    my $docs = yaml.all.load($yaml);

    # dump data to YAML
    my $yaml = yaml.dump(%data1, @data2, ...);
    my @docs = (%data1, @data2);
    my $yaml = yaml.dump(@docs);


# Features

- Load and Dump strings, numbers, booleans, arrays, hashes, (objects)
- Load and Dump Aliases/Anchors, including cyclic structures

# TODO

- Tags
- Files and Filehandles
- Error messages
- Allow other parsers/emitters as a backend
- Other low level API stuff


# SEE ALSO

[YAMLish](https://github.com/Leont/yamlish) is a pure-perl6 module for
YAML that doesn't rely on an external library like `YAML` currently does.

