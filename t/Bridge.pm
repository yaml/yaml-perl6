use v6;

module Bridge;

use YAML;

our sub eval_perl($this) {
    return eval $this.value;
    CATCH {
        return "$!";
    }
}

our sub dump_to_yaml($this) {
    return YAML::dump($this.value);
}
