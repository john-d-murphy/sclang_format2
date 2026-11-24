// Source: Classes/LFGauss.schelp block 4 (part 2/5)
(
SynthDef(\gabor, { |out, i_freq = 440, i_sustain = 1, i_pan = 1, i_amp = 0.1, i_width = 0.25|
	var env = LFGauss.ar(i_sustain, i_width, loop: 0, doneAction: Done.freeSelf).range;
	var son = FSinOsc.ar(i_freq, 0.5pi, env);
	OffsetOut.ar(out, Pan2.ar(son, i_pan, i_amp));
}).add;
)
