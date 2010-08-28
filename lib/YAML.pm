use v6;

module YAML;

use YAML::Dumper;
use YAML::Loader;

our $*VERSION = '0.01';

our sub dump($object) is export {
    return YAML::Dumper.new.dump($object);
    CATCH {
        say "Error: $!";
    }
}

our sub load($yaml) is export {
    return YAML::Loader.new.load($yaml);
    CATCH {
        say "Error: $!";
    }
}
