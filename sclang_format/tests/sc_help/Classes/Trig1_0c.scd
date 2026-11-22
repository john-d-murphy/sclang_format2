// Source: Classes/Trig1.schelp block 0 (part 3/4)
(

SynthDef("trig1", { |dur = 0.125|
	var gate;
	gate = Trig1.kr(1.0, dur);
	OffsetOut.ar(0,
		SinOsc.ar(800, 0.3)
		* EnvGen.kr(
			Env([0, 0.1, 0.1, 0], [0.01, 1.0, 0.01], [-4, 4], 2),
			gate,
			doneAction: Done.freeSelf)
	)
}).add;

Routine({
	1.0.wait;
	100.do({
		s.sendBundle(0.05, ["s_new", "trig1", -1, 0, 0, 0, rrand(0.02, 0.25)]);
		0.25.wait
	})
}).play(SystemClock)

)
