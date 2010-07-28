use TestML::Runner::TAP;

TestML::Runner::TAP.new(
    document => 'load.tml',
    bridge => 't::Bridge',
).run();
