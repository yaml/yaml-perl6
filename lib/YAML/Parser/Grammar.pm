use v6;

grammar YAML::Parser::Grammar;

rule TOP { <stream> }

rule stream {
    <document>*
}

rule document {
    "---\n"
    <block_mapping>
}

rule block_node {
}

rule flow_node { ... }

