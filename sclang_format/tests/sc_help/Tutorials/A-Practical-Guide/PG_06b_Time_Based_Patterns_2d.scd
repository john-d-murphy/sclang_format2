// Source: Tutorials/A-Practical-Guide/PG_06b_Time_Based_Patterns.schelp block 2 (part 4/5)
r = fork {
	var stream = e.asStream;
	12.do({
		stream.next.postln;
		0.25.wait;
	});
};

// Use an envelope to pan notes from left to right and back
p = Pbind(
	\degree, Pwhite(-4, 11, 32),
	\pan, Env(#[-1, 1, -1], #[2, 2], \sin),
	\dur, 0.125
).play;
