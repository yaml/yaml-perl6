use TestML::Runner::TAP;

TestML::Runner::TAP.new(
    document => 'dump.tml',
    bridge => 't::Bridge',
).run();
