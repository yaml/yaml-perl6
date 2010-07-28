use v6;

use YAML::Parser;

class YAML::Loader;

method load($stream) {
    YAML::Parser.parse($stream);
}
