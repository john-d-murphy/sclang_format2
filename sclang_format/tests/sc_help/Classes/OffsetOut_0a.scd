// Source: Classes/OffsetOut.schelp block 0 (part 1/4)
(
SynthDef("help-OffsetOut",
	{ arg out=0, freq=440, dur=0.05;
		var env;
		env = EnvGen.kr(Env.perc(0.01, dur, 0.2), doneAction: Done.freeSelf);
		OffsetOut.ar(out, SinOsc.ar(freq, 0, env))
}).send(s);

SynthDef("help-Out",
	{ arg out=0, freq=440, dur=0.05;
		var env;
		env = EnvGen.kr(Env.perc(0.01, dur, 0.2), doneAction: Done.freeSelf);
		//compare to Out:
		Out.ar(out, SinOsc.ar(freq, 0, env))
}).send(s);
)
