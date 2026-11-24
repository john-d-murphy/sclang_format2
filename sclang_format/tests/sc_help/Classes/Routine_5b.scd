// Source: Classes/Routine.schelp block 5 (part 2/2)
(
r = Routine {
		199.yield;
		189.yield;
		Routine { 100.do { |i| i.yield } }.idle(6);
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
