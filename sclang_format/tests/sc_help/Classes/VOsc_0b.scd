// Source: Classes/VOsc.schelp block 0 (part 2/6)
(
x = SynthDef("help-VOsc", { |out = 0, bufoffset = 0|
	// mouse x controls the wavetable position
	var bufindex = MouseX.kr(0, ~bufs.size - 1) + bufoffset;

	Out.ar(out,
		VOsc.ar(bufindex, [120, 121], 0, 0.3)
	)
}).play(s, [\out, 0, \bufoffset, ~bufs.first.bufnum]);
)
