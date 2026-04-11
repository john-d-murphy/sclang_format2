// Source: Tutorials/JITLib/basic_live_coding_techniques.schelp block 0 (part 3/15)
(
SynthDef(\x, { |out, freq = 440|
	Out.ar(out,
		Ringz.ar(Dust.ar(40), freq, 0.1)
	)
}).send(s)
)
