use v6;
class YAML::API {
    use LibYAML;
    use LibYAML::Parser;
    use LibYAML::Emitter;
    use YAML::Loader;
    use YAML::Reader;
    use YAML::Writer;
    use YAML::Dumper;

    has LibYAML::Parser $.parser is rw;
    has LibYAML::Emitter $.emitter is rw;
    has YAML::Reader $.reader is rw;
    has YAML::Writer $.writer is rw;
    has YAML::Dumper $.dumper is rw;
    has YAML::Loader $.loader is rw;

    method load(Str $input) {
        $.reader = YAML::Reader.new(
            input => $input,
        );
        $.loader = YAML::Loader.new;
        $.parser = LibYAML::Parser.new(
            reader => $.reader,
            loader => $.loader,
        );
        $.parser.parse-input();
        my @docs = $.loader.docs;
        return @docs;
    }

    method dump(*@docs) {
        $.writer = YAML::Writer.new(
        );
        $.emitter = LibYAML::Emitter.new(
            writer => $.writer,
        );
        $.dumper = YAML::Dumper.new(
            docs => @docs,
            emitter => $.emitter,
        );
        my $yaml = $.dumper.dump();
        return $yaml;
    }

}
