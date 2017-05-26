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
        # we can't just do:
        # $hash = $array.Hash
        # because we have a reference to $hash elsewhere (in %.anchors)
        for 0, 2 ...^ $array.elems -> $i {
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
        my $style = $event<style>;
        my $svalue = $event<value>;
        my $value = self.load-scalar($style, $svalue);
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

}
