// Source: Classes/SubsampleOffset.schelp block 0 (part 4/5)
(
SynthDef("Help_Subsample_Grain",
	{ |out = 0, freq = 440, sustain = 0.005, attack = 0.001|
		var env, offset, sig, sd;

		sd = SampleDur.ir;
		offset = (1 - SubsampleOffset.ir) * sd;
		// free synth after delay:
		Line.ar(1, 0, attack + sustain + offset, doneAction: Done.freeSelf);
		env = EnvGen.kr(Env.perc(attack, sustain, 0.2));
		sig = SinOsc.ar(freq, 0, env);

		sig = DelayC.ar(sig, sd * 4, offset);
		OffsetOut.ar(out, sig);
	}, [\ir, \ir, \ir, \ir]).add;
)
