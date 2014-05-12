use TestML::Runner::TAP;

use lib '.';

TestML::Runner::TAP.new(
    document => 'strings.tml',
    bridge => 't::Bridge',
).run();
