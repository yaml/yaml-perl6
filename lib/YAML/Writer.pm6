use v6;

unit class YAML::Writer;

has Str $.output;

method write(Str $str) {
    $.output ~= $str;
}
