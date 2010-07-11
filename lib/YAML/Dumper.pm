class YAML::Dumper;

has $.stream is rw;
has $.seen = {};
has $.anchors = {};
has $.level is rw = 0;

method dump($object) {
    self.prewalk($object);
    self.stream = '';
    self.dump_top($object);
    return self.stream;
}

method prewalk($node) {
}

method dump_top($node) {
    $.stream ~= '---';
    if $node.WHAT eq any('Str()', 'Int()') {
        $.stream ~= ' ';
    }
    $.dump_node($node);
    if $node.WHAT eq any('Str()', 'Int()') {
        $.stream ~= "\n";
    }
    $.stream ~= "...\n";
}

method dump_node($node) {
    if $node.WHAT eq 'Array()' {
        $.stream ~= "\n";
        $.dump_seq($node);
    }
    elsif $node.WHAT eq 'Hash()' {
        $.stream ~= "\n";
        $.dump_map($node);
    }
    elsif $node.WHAT eq 'Str()' {
        $.dump_str($node);
    }
    elsif $node.WHAT eq 'Int()' {
        $.dump_str($node);
    }
    else {
        die "Can't dump " ~ $node.WHAT;
    }
}

method dump_seq(@node) {
    for @node -> $elem {
        $.stream ~= ' ' x $.level;
        $.stream ~= '- ';
        $.dump_node($elem);
        $.stream ~= "\n";
    }
}

method dump_map(%node) {
    for %node.keys.sort -> $key {
        $.stream ~= ' ' x $.level;
        $.dump_node($key);
        $.stream ~= ': ';
        $.dump_node(%node{$key});
        $.stream ~= "\n";
    }
}

method dump_str($node) {
    $.stream ~= $node.Str;
}

