use v6;
class YAML::API {

method load(Str $input) {
    use LibYAML;
    my $parser = LibYAML::Parser.new;
    my $data = $parser.parse-string($input);
    return $data;
#    require YAML::Perl::Loader;
#    require YAML::PP::Parser;
#    require YAML::Reader;
#    my $reader = YAML::Reader->new(
#        input => $input
#    );
#    my $parser = YAML::PP::Parser->new(
#        reader => $reader,
#    );
#    my $loader = YAML::Perl::Loader->new(
#        parser => $parser,
#    );
#    return $loader->load;
}


}
