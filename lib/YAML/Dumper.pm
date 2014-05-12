use v6;
class YAML::Dumper;

has $.out is rw = [];
has $.seen is rw = {};
has $.tags is rw = {};
has $.anchors is rw = {};
has $.level is rw = 0;
has $.id is rw = 1;
has $.info is rw = [];

method dump($object) {
    $.prewalk($object);
    $!seen = {};
    $.dump_document($object);
    return $.out.join('');
}

method dump_document($node) {
    push $.out, '---';
    $.dump_node($node);
    push $.out, "\n", "...", "\n";
}

method dump_collection($node, $kind, $function) {
    if $node.elems == 0 {
        push $.out, ' ', $kind eq 'map' ?? '{}' !! '[]';
        return;
    }
    $.level++;
    push $.info, {
        kind => $kind,
    };
    given ++$.seen{$node.WHICH} {
        when 1 {
            $function.();
        }
        default {
            $.dump_alias($node);
        }
    }
    pop $.info;
    $.level--;
}

method check_special($node) {
    my $first = 1;
    if $.anchors{$node.WHICH} :exists {
        push $.out, ' ', '&' ~ $.anchors{$node.WHICH};
        $first = 0;
    }
    if $.tags{$node.WHICH} :exists {
        push $.out, ' ', '!' ~ $.tags{$node.WHICH};
        $first = 0;
    }
    return $first;
}

method indent($first) {
    my $seq_in_map = 0;
    if $.level > 1 {
        if $first && $.info[*-2]<kind> eq 'seq' {
            push $.out, ' ';
            return;
        }
        if $.info[*-1]<kind> eq 'seq' && $.info[*-2]<kind> eq 'map' {
            $seq_in_map = 1;
        }
    }
    push $.out, "\n";
    push $.out, ' ' x (($.level - 1 - $seq_in_map) * 2);
}

multi method dump_node(Hash $node) {
    $.dump_collection($node, 'map', sub {
        my $first = $.check_special($node);
        for $node.keys.sort -> $key {
            $.indent($first);
            $.dump_string($key.Str);
            push $.out, ':';
            $.dump_node($node{$key});
            $first = 0;
        }
    });
}

multi method dump_node(Array $node) {
    $.dump_collection($node, 'seq', sub {
        my $first = $.check_special($node);
        for @($node) -> $elem {
            $.indent($first);
            push $.out, '-';
            $.dump_node($elem);
            $first = 0;
        }
    });
}

multi method dump_node(Str $node) {
    push $.out, ' ';
    $.dump_string($node);
}

multi method dump_node(Int $node) {
    push $.out, ' ', $node.Str;
}

multi method dump_node(Bool $node) {
    push $.out, ' ', $node.WHICH eq Bool::True.WHICH ?? 'true' !! 'false';
}

multi method dump_node(Any $node) {
    my $type = $node.^name;   #RAKUDO (should use Str.substr)
    return $.dump_null if $type eq 'Any';
    return $.dump_object($node, $type);
}

# multi method dump_node($node) {
#     die "Can't dump a node of type " ~ $node.WHAT;
# }

method dump_alias($node) {
    push $.out, ' ', '*' ~ $.anchors{$node.WHICH};
}

method dump_string($node) {
    return $.dump_single($node) if $node ~~ /^ [ true | false | null | '~' ] $/;
    return $.dump_double($node) if $node ~~ /^ ' ' /;
    return $.dump_double($node) if $node ~~ / ' ' $/;
    return $.dump_double($node) if $node ~~ / \n | '"' /;
    return $.dump_unquoted($node);
}

method dump_single($node) {
    push $.out, "'", $node.subst(/"'"/, "''", :g), "'";
}

method dump_double($node) {
    my $text = $node\
        .subst(/'"'/, '\\"', :g)\
        .subst(/\n/, '\\n', :g);
    push $.out, '"', $text, '"';
}

method dump_unquoted($node) {
    push $.out, $node;
}

method dump_null() {
    push $.out, ' ', '~';
}

method dump_object($node, $type) {
    my $repr = {};
    $.tags{$repr.WHICH} = $type;
    for $node.^attributes -> $a {
        my $name = $a.name.substr(2);
        my $value = $a.get_value($node);
        $repr{$name} = $value;
    }
    $.dump_node($repr);
}


# Prewalk methods
method check_reference($node, $function) {
    my $id = $node.WHICH;
    given ++$.seen{$id} {
        when 1 {
            $function.();
        }
        when 2 {
            $.anchors{$id} = $.id++;
        }
    }
}

multi method prewalk(Hash $node) {
    $.check_reference($node, sub {
        for $node.values -> $value {
            $.prewalk($value);
        }
    });
}

multi method prewalk(Array $node) {
    $.check_reference($node, sub {
        for @($node) -> $value {
            $.prewalk($value);
        }
    });
}

multi method prewalk($node) {
    return;
    return if $node.WHAT eq any('Str()', 'Int()', 'Bool()', 'Any()');
#     die "Can't prewalk a node of type " ~ $node.WHAT;
}

# vim: ft=perl6
