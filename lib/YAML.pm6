use v6;
class YAML {

sub yaml() is export {
    require YAML::API;
    my $api = YAML::API.new;
    return $api;
}

}
