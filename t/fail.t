use TestML::Runner::TAP;

TestML::Runner::TAP.new(
    document => 'fail.tml',
    bridge => 't::Bridge',
).run();
