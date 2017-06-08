use v6;

unit class YAML::Dumper;

has @.docs is rw;
has $.emitter is rw;
has %.objects;
has %.aliases;
has $.alias-id;

method dump() {
    my $yaml;

    $!emitter.init;
    $!emitter.buf = '';
    $!emitter.set-output-string;

    $!emitter.stream-start-event;

    for @.docs -> $doc {
        %!objects = ();
        %!aliases = ();
        $!alias-id = '1';

        $!emitter.document-start-event(implicit => False);

        self.anchors($doc);
        self.dump-object($doc);

        $!emitter.document-end-event(implicit => False);
    }

    $!emitter.stream-end-event;

    $!emitter.delete;
    $yaml = $!emitter.buf;

#    $yaml = $!emitter.dump-string(@.docs);
    return $yaml;
}

multi method dump-object(Mu:U $undef, Str :$tag) {
    $!emitter.scalar-event(
        value => '~',
        anchor => Str,
        tag => $tag,
        style => "plain",
    );
}

multi method dump-object(Bool:D $bool, Str :$tag) {
    $!emitter.scalar-event(
        value => $bool ?? 'true' !! 'false',
        anchor => Str,
        tag => $tag,
        style => "plain",
    );
}

multi method dump-object(Int:D $int, Str :$tag) {
    $!emitter.scalar-event(
        value => $int.Str,
        anchor => Str,
        tag => $tag,
        style => "plain",
    );
}

multi method dump-object(Rat:D $rat, Str :$tag) {
    $!emitter.scalar-event(
        value => $rat.Str,
        anchor => Str,
        tag => $tag,
        style => "plain",
    );
}

multi method dump-object(Positional:D $list, Str :$tag) {

    return $!emitter.alias-event(alias => $_) with %!aliases{ $list.WHICH };

    my $anchor = Str;
    if %!objects{ $list.WHICH } > 1 {
        $anchor = %!aliases{ $list.WHICH } = $!alias-id++;
    }

    $!emitter.sequence-start-event(
        anchor => $anchor,
        tag => $tag,
    );

    for $list -> $node {
        self.dump-object($node);
    }

    $!emitter.sequence-end-event();
}

multi method dump-object(Associative:D $map, Str :$tag) {

    return $!emitter.alias-event(alias => $_) with %!aliases{ $map.WHICH };

    my $anchor = Str;
    if %!objects{ $map.WHICH } > 1 {
        $anchor = %!aliases{ $map.WHICH } = $!alias-id++;
    }

    $!emitter.mapping-start-event(
        anchor => $anchor,
        tag => $tag,
    );
    for $map.keys.sort -> $key {
        self.dump-object($key);
        self.dump-object($map{ $key });
    }
    $!emitter.mapping-end-event();
}

multi method dump-object(Str:D $str, Str :$tag) {
    my $style = "any";
    given $str {
        when ''|'null'|'true'|'false' {
            $style = "single";
        }
    }
    $!emitter.scalar-event(
        value => $str,
        anchor => Str,
        tag => $tag,
        style => $style,
    );
}

multi method dump-object(Any:D $node, Str :$tag) {
    return $!emitter.alias-event(alias => $_) with %!aliases{ $node.WHICH };

    my $anchor = Str;
    if %!objects{ $node.WHICH } > 1 {
        $anchor = %!aliases{ $node.WHICH } = $!alias-id++;
    }

    $!emitter.mapping-start-event(
        anchor => $anchor,
        tag => $tag,
    );
    for $node.^attributes.sort -> $key {
        my $name = $key.name.substr(2);
        my $value = $key.get_value($node);
        self.dump-object($name);
        self.dump-object($value);
    }
    $!emitter.mapping-end-event();
}

multi method anchors(Mu:U $node) { }
multi method anchors(Int:D $node) { }
multi method anchors(Rat:D $node) { }
multi method anchors(Bool:D $node) { }
multi method anchors(Str:D $node) { }

multi method anchors(Associative:D $node) {
    return if %!objects{ $node.WHICH }++ > 1;

    self.anchors($_) for $node.values;
}

multi method anchors(Positional:D $node) {
    return if %!objects{ $node.WHICH }++ > 1;

    self.anchors($_) for $node.values;
}

multi method anchors(Any:D $node) {
    return if %!objects{ $node.WHICH }++ > 1;

    for $node.^attributes -> $key {
        my $value = $key.get_value($node);
        self.anchors($value);
    }
}

