// Source: Classes/LinkClock.schelp block 1 (part 1/10)
(
s.waitForBoot({
	SynthDef(\click, { |freq = 400, amp = 0.2|
		var sig = SinOsc.ar(freq, 0.5pi) *
			Env.perc(0.001, 0.06).ar(Done.freeSelf, levelScale: amp);
		OffsetOut.ar(0, sig.dup)
	}).add;
});
)
