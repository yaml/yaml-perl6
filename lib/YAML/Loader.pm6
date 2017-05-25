use v6;

class YAML::Loader {
    has @.stack is rw;
    has @.docs is rw;
    has %.anchors is rw;

    method document-start-event(Hash $event, $parser) {
        my @array;
        @.stack = item(@array);
    }

    method document-end-event(Hash $event, $parser) {
        my $doc = @.stack.pop;
        @.docs.push: $doc[0];
        my @array;
        @.stack = item(@array);
    }

    method mapping-start-event(Hash $event, $parser) {
        my $anchor = $event<anchor>;
        my %hash;
        if (defined $anchor) {
            %.anchors{ $anchor } = %hash;
        }
        push @.stack: %hash;
        my @array;
        push @.stack: @array;
    }

    method mapping-end-event(Hash $event, $parser) {
        my $array = pop @.stack;
        my $hash = pop @.stack;
        loop (my $i = 0; $i < $array.elems; $i += 2) {
            my $key = $array[ $i ];
            my $value = $array[ $i + 1 ];
            $hash{ $key } = $value;
        }
        my $last = @.stack[*-1];
        $last.push: $hash;
    }

    method sequence-start-event(Hash $event, $parser) {
        my $anchor = $event<anchor>;
        my @array;
        if (defined $anchor) {
            %.anchors{ $anchor } = @array;
        }
        push @.stack: (@array);
    }

    method sequence-end-event(Hash $event, $parser) {
        my $array = pop @.stack;
        my $last = @.stack[*-1];
        $last.push: $array;
    }

    method scalar-event(Hash $event, $parser) {
        my $anchor = $event<anchor>;
        my $value = $event<value>;
        if (defined $anchor) {
            %.anchors{ $anchor } = $value;
        }
        my $last = @.stack[*-1];
        $last.push: $value;
    }

    method alias-event(Hash $event, $parser) {
        my $alias = $event<alias>;
        my $value;
        if ($.anchors{ $alias }:exists) {
            $value = $.anchors{ $alias };
        }
        @.stack[*-1].push: $value;
    }


}
