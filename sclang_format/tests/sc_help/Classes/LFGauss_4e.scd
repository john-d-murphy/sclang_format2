// Source: Classes/LFGauss.schelp block 4 (part 5/5)
(
SynthDef(\gabor, { |out, i_freq = 440, i_sustain = 1, i_pan = 1, i_amp = 0.1, i_width = 0.25|
	var env = EnvGen.ar(Env.sine(i_sustain * i_width), doneAction: Done.freeSelf);
	var son = FSinOsc.ar(i_freq, 0.5pi, env);
	OffsetOut.ar(out, Pan2.ar(son, i_pan, i_amp));
}).add;
)
