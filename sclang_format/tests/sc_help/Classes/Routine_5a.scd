// Source: Classes/Routine.schelp block 5 (part 1/2)
(
r = Routine {
		199.yield;
		189.yield;
		200.idle(6);
		199.yield;
		189.yield;
};

fork {
	loop {
		r.value.postln;
		1.wait;
	}
}
);
