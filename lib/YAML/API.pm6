use v6;
unit class YAML::API;

use LibYAML;
use LibYAML::Parser;
use LibYAML::Emitter;
use YAML::Loader;
use YAML::Reader;
use YAML::Writer;
use YAML::Dumper;

has LibYAML::Parser $.parser is rw;
has LibYAML::Emitter $.emitter is rw;
has YAML::Reader $.reader is rw;
has YAML::Writer $.writer is rw;
has YAML::Dumper $.dumper is rw;
has YAML::Loader $.loader is rw;

has Bool $!all = False;

method load(Str $input) {
    $.reader = YAML::Reader.new(
        input => $input,
    );
    $.loader = YAML::Loader.new;
    $.parser = LibYAML::Parser.new(
        reader => $.reader,
        loader => $.loader,
    );
    $.parser.parse-input();
    my @docs = $.loader.docs;

    return $!all ?? @docs !! @docs[0];
}

method dump(*@docs) {
    $.writer = YAML::Writer.new(
    );
    $.emitter = LibYAML::Emitter.new(
        writer => $.writer,
    );
    $.dumper = YAML::Dumper.new(
        docs => @docs,
        emitter => $.emitter,
    );
    my $yaml = $.dumper.dump();
    return $yaml;
}

multi method all {
    $!all = True;
    return self;
}

multi method all(Bool:D $all) {
    $!all = $all;
    return self;
}

multi method all(Bool:U $all) {
    return $!all;
}

multi method single {
    $!all = False;
    return self;
}

multi method single(Bool:D $all) {
    $!all = not $all;
    return self;
}

multi method single(Bool:U $all) {
    return not $!all;
}

