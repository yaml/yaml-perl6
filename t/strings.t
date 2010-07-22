use TestML::Runner::TAP;

TestML::Runner::TAP.new(
    document => 'strings.tml',
    bridge => 't::Bridge',
).run();
