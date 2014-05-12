use TestML::Runner::TAP;

use lib '.';

TestML::Runner::TAP.new(
    document => 'dump.tml',
    bridge => 't::Bridge',
).run();
