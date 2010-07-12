class YAML::Dumper;

has $.out = [];
has $.seen = {};
has $.anchors = {};
has $.level is rw = 0;
has $.id is rw = 1;
has $.stack = [];

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

multi method dump_node(Hash $node) {
    $.level++;
    for $node.keys.sort -> $key {
        push $.out, "\n";
        push $.out, ' ' x (($.level - 1) * 2);
        push $.out, $key.Str;
        push $.out, ':';
        $.dump_node($node{$key});
    }
    $.level--;
}

multi method dump_node(Array $node) {
    $.level++;
    for @($node) -> $elem {
        push $.out, "\n";
        push $.out, ' ' x (($.level - 1) * 2);
        push $.out, '-';
        $.dump_node($elem);
    }
    $.level--;
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

