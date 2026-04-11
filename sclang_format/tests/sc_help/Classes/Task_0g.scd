// Source: Classes/Task.schelp block 0 (part 7/9)
(
t = Task({
	["go", thisThread.clock.beats].postln;
	inf.do({ arg i;
		2.wait;
		[ "wake up", i ].postln;
	});
});

fork {
	t.start;
	0.1.wait;
	t.stop;
	0.1.wait;
	t.start;
	6.wait;
	t.stop;
};
)
