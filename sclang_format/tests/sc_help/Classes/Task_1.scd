// Source: Classes/Task.schelp block 1
(
r = Routine({
	["go", thisThread.clock.beats].postln;
	inf.do({ |i|
		2.wait;
		["wake up", i].postln;
	});
});

fork {
	t = PauseStream(r);
	t.start;  // prints "go..."
	0.1.wait;
	t.stop;   // but stop before the loop prints
	0.1.wait;
	t = PauseStream(r);
	t.start;  // prints "go..."
	6.wait;   // loop is allowed to run 2 cycles
	t.stop;
};
)
