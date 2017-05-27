use v6;

class YAML::Dumper {
    has @.docs is rw;
    has $.emitter is rw;

    method dump() {
        my $yaml = $.emitter.dump-string(@.docs);
        return $yaml;
    }
}
