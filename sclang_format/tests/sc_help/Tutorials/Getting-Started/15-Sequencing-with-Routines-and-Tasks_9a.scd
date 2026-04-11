// Source: Tutorials/Getting-Started/15-Sequencing-with-Routines-and-Tasks.schelp block 9 (part 1/2)
(
t = Task({
	loop {
		s.makeBundle(s.latency, {
			Synth(\singrain, [freq: exprand(400, 1200), sustain: 0.08]);
		});
		0.1.wait;
	}
}).play;
)
