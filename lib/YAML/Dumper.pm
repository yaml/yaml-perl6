class YAML::Dumper;

has $.out = [];
has $.seen = {};
has $.anchors = {};
has $.level is rw = 0;
has $.id is rw = 1;
has $.info = [];

method dump($object) {
    $.prewalk($object);
    $.dump_document($object);
    return $.out.join('');
}

method dump_document($node) {
    push $.out, '---';
    $.dump_node($node);
    push $.out, "\n", "...", "\n";
}

method dump_collection($function, $kind) {
    $.level++;
    push $.info, {
        kind => $kind,
    };
    $function.();
    pop $.info;
    $.level--;
}

method indent($first) {
    if ($first && $.level > 1 && $.info[*-2]<kind> eq 'seq') {
        push $.out, ' ';
    }
    else {
        push $.out, "\n";
        push $.out, ' ' x (($.level - 1) * 2);
    }
}

multi method dump_node(Hash $node) {
    $.dump_collection(sub {
        my $first = 1;
        for $node.keys.sort -> $key {
            $.indent($first);
            push $.out, $key.Str;
            push $.out, ':';
            $.dump_node($node{$key});
            $first = 0;
        }
    }, 'map');
}

multi method dump_node(Array $node) {
    $.dump_collection(sub {
        my $first = 1;
        for @($node) -> $elem {
            $.indent($first);
            push $.out, '-';
            $.dump_node($elem);
            $first = 0;
        }
    }, 'seq');
}

multi method dump_node(Str $node) {
    push $.out, ' ', $node.Str;
}

multi method dump_node(Int $node) {
    push $.out, ' ', $node.Str;
}

multi method dump_node($node) {
    die "Can't dump a node of type " ~ $node.WHAT;
}

# Prewalk methods
multi method prewalk(Hash $node) {
    my $id = $node.WHICH;
    given ++$.seen{$id} {
        when 1 {
            for $node.values -> $value {
                $.prewalk($value);
            }
        }
        when 2 {
            $.anchors{$id} = $.id++;
        }
    }
}

multi method prewalk(Array $node) {
    my $id = $node.WHICH;
    given ++$.seen{$id} {
        when 1 {
            for @($node) -> $value {
                $.prewalk($value);
            }
        }
        when 2 {
            $.anchors{$id} = $.id++;
        }
    }
}

multi method prewalk($node) {
    return if $node.WHAT eq any('Str()', 'Int()');
    die "Can't prewalk a node of type " ~ $node.WHAT;
}

