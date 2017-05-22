use v6;
module YAML {
    sub yaml() is export(:DEFAULT) {
        require YAML::API;
        say "hi";
    }
}
