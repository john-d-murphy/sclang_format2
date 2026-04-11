// Source: Tutorials/Getting-Started/15-Sequencing-with-Routines-and-Tasks.schelp block 1 (part 1/4)
(
r = Routine({
	var delta;
	loop {
		delta = rrand(1, 3) * 0.5;
		"Will wait ".post; delta.postln;
		delta.yield;
	}
});
)
