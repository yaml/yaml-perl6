use v6;
class YAML::API {
    use LibYAML;
    use YAML::Loader;
    use YAML::Reader;

    has LibYAML::Parser $.parser is rw;
    has YAML::Loader $.loader is rw;
    has YAML::Reader $.reader is rw;

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

}
