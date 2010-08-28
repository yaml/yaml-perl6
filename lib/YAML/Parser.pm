use v6;
class YAML::Parser;

use YAML::Parser::Grammar;

method parse($stream) {
    YAML::Parser::Grammar.parse($stream);
}
