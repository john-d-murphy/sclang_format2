// Source: Classes/Linen.schelp block 0 (part 5/8)
(
SynthDef("help-Linen",{ arg out = 0, dur = 0.1;
	var gate;
	gate = Trig.kr(1.0, dur);
	Out.ar(out,
		Linen.kr(gate, 0.01, 0.6, 1.0, doneAction: Done.freeSelf) * SinOsc.ar(440, 0, 0.1)
	)
}).play(nil, [\out, 0, \dur, 2.0]);
)
