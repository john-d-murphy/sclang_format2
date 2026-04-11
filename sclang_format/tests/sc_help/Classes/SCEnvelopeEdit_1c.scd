// Source: Classes/SCEnvelopeEdit.schelp block 1 (part 3/4)
(
SynthDef("sineBlip", {
	arg freq = 440, vol = 0.1, la0, la1, la2, la3, la4, ta0, ta1, ta2, ta3, crva,
		lf0, lf1, lf2, lf3, lf4, tf0, tf1, tf2, tf3, crvf;
	var signal, fenv, aenv;
	fenv = EnvGen.ar(Env([lf0, lf1, lf2, lf3, lf4], [tf0, tf1, tf2, tf3], crvf));
	aenv = EnvGen.ar(Env([la0, la1, la2, la3, la4], [ta0, ta1, ta2, ta3], crva), doneAction: Done.freeSelf);
	signal = SinOsc.ar([freq, freq*2] * fenv) * aenv * vol;
	Out.ar(0, signal.dup);
}).add;
)
