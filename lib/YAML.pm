use v6;

module YAML;

use YAML::Dumper;

our $*VERSION = '0.01';

our sub dump($object) is export {
    return YAML::Dumper.new.dump($object);
    CATCH {
        say "Error: $!";
    }
}

our sub load($yaml) is export {
    die "YAML.load is not yet implemented";
}
