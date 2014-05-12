use TestML::Runner::TAP;

use lib '.';

TestML::Runner::TAP.new(
    document => 'fail.tml',
    bridge => 't::Bridge',
).run();
