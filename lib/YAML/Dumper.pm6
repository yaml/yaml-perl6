use v6;

unit class YAML::Dumper;

has @.docs is rw;
has $.emitter is rw;

method dump() {
    my $yaml;

    $.emitter.init;
    $.emitter.buf = '';
    $.emitter.set-output-string;

    $.emitter.stream-start-event;

    for @.docs -> $doc {
        $.emitter.document-start-event(False);

        self.dump-object($doc);

        $.emitter.document-end-event(False);
    }

    $.emitter.stream-end-event;

    $.emitter.delete;
    $yaml = $.emitter.buf;

#    $yaml = $.emitter.dump-string(@.docs);
    return $yaml;
}

multi method dump-object(Mu:U $undef, Str :$tag) {
    $.emitter.scalar-event(Str, $tag, '~', "plain");
}

multi method dump-object(Bool:D $bool, Str :$tag) {
    $.emitter.scalar-event(Str, $tag, $bool ?? 'true' !! 'false', "plain");
}

multi method dump-object(Int:D $int, Str :$tag) {
    $.emitter.scalar-event(Str, $tag, $int.Str, "plain");
}

multi method dump-object(Rat:D $rat, Str :$tag) {
    $.emitter.scalar-event(Str, $tag, $rat.Str, "plain");
}

multi method dump-object(Positional:D $list, Str :$tag) {
    $.emitter.sequence-start-event(Str, $tag);

    for $list -> $node {
        self.dump-object($node);
    }

    $.emitter.sequence-end-event();
}

multi method dump-object(Associative:D $map, Str :$tag) {
    $.emitter.mapping-start-event(Str, $tag);
    for $map.keys.sort -> $key {
        self.dump-object($key);
        self.dump-object($map{ $key });
    }
    $.emitter.mapping-end-event();
}

multi method dump-object(Str:D $str, Str :$tag) {
    my $style = "any";
    given $str {
        when ''|'null'|'true'|'false' {
            $style = "single";
        }
    }
    $.emitter.scalar-event(Str, $tag, $str, $style);
}

