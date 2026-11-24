// Source: Classes/LinkClock.schelp block 1 (part 5/10)
(
r = Task {
	loop {
		s.makeBundle(s.latency, {
			Synth(\click, [freq: exprand(500, 1200)])
		});
		1.wait;
	}
}.play(l, quant: 4);
)
