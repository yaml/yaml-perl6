use v6;

unit class YAML::Dumper;

has @.docs is rw;
has $.emitter is rw;

method dump() {
    my $yaml = $.emitter.dump-string(@.docs);
    return $yaml;
}
