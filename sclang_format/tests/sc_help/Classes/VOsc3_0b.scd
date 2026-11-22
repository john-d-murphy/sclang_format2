// Source: Classes/VOsc3.schelp block 0 (part 2/7)
(
x = SynthDef("help-VOsc", { |out = 0, bufoffset = 0, freq = 240|
	// mouse x controls the wavetable position
	var bufindex = MouseX.kr(0, ~bufs.size - 1) + bufoffset;

	Out.ar(out,
		VOsc3.ar(
			bufindex,
			freq + [0, 1],
			freq + [0.37, 1.1],
			freq + [0.43, -0.29],
			0.3
		)
	)
}).play(s, [\out, 0, \bufoffset, ~bufs.first.bufnum, \freq, 240]);
)
