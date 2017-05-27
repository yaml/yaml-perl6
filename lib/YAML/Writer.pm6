use v6;

class YAML::Writer {
    has Str $.output;

    method write(Str $str) {
        $.output ~= $str;
    }
}
