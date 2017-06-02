use v6;

unit class YAML::Loader;

has @.stack is rw;
has @.docs is rw;
has %.anchors is rw;

method stream-start-event(Hash $event, $parser) {
    @.docs = ();
    %.anchors = ();
    @.stack = ();
}

method stream-end-event(Hash $event, $parser) {
}

method document-start-event(Hash $event, $parser) {
    @.stack = item(my @array);
}

method document-end-event(Hash $event, $parser) {
    my $doc = @.stack.pop;
    @.docs.push: $doc[0];
    @.stack = item(my @array);
}

method mapping-start-event(Hash $event, $parser) {
    my $anchor = $event<anchor>;
    my %hash;
    if (defined $anchor) {
        %.anchors{ $anchor } = %hash;
    }
    push @.stack: %hash;
    push @.stack: my @array;
}

method mapping-end-event(Hash $event, $parser) {
    my $array = pop @.stack;
    my $hash = pop @.stack;
    # we can't just do:
    # $hash = $array.Hash
    # because we have a reference to $hash elsewhere (in %.anchors)
    for 0, 2 ...^ $array.elems -> $i {
        my $key = $array[ $i ];
        my $value = $array[ $i + 1 ];
        $hash{ $key } = $value;
    }
    @.stack[*-1].push: $hash;
}

method sequence-start-event(Hash $event, $parser) {
    my $anchor = $event<anchor>;
    my @array;
    if (defined $anchor) {
        %.anchors{ $anchor } = @array;
    }
    push @.stack: @array;
}

method sequence-end-event(Hash $event, $parser) {
    my $array = pop @.stack;
    @.stack[*-1].push: $array;
}

method scalar-event(Hash $event, $parser) {
    my $anchor = $event<anchor>;
    my $value = self.load-scalar($event<style>, $event<value>);
    if (defined $anchor) {
        %.anchors{ $anchor } = $value;
    }
    @.stack[*-1].push: $value;
}

method alias-event(Hash $event, $parser) {
    my $alias = $event<alias>;
    my $value;
    if (%.anchors{ $alias }:exists) {
        $value = %.anchors{ $alias };
    }
    @.stack[*-1].push: $value;
}

method load-scalar(Str $style, Str $svalue) {
    if ($style eq "plain") {

        my $value = do given $svalue {
            when ''|'null'                        { Any }
            when 'true'                           { True }
            when 'false'                          { False }

            when /^[<[-+]>? <[0..9]>+         |
                   0o <[0..7]>+               |
                   0x <[0..9a..fA..F]>+ ]$/       { .Int }

            when /^<[-+]>? [ 0 | <[0..9]>*]
                   '.' <[0..9]>+ $/               { .Rat }

            default                               { $_ }
        }

        return $value;
    }
}

