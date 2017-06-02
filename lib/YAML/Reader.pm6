use v6;

unit class YAML::Reader;

has Str $.input is rw;

method read() {
    return $.input;
}

