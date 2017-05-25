use v6;

class YAML::Reader {
    has Str $.input is rw;

    method read() {
        return $.input;
    }

}
