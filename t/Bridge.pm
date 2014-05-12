use v6;

module t::Bridge;

use YAML;

our sub eval_perl($this) {
    return EVAL $this.value;
    CATCH {
        return "$!";
    }
}

our sub dump_to_yaml($this) {
    return YAML::dump($this.value);
}
