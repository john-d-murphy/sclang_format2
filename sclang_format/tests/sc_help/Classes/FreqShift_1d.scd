// Source: Classes/FreqShift.schelp block 1 (part 4/6)
(
SynthDef("frqShift1", { |out, freq|
	var e1,snd,snd2,in;
	in = FreqShift.ar(InFeedback.ar(0, 1) * 3.2, XLine.ar(0.01, freq * 1.5, 1)); // shift the feedback
	e1 = Env.new([0, 0.1, 0], [0.02, 2.98]);
	snd = SinOsc.ar(freq, 0, EnvGen.ar(e1, 1, doneAction: Done.freeSelf));
	snd2 = FreqShift.ar(snd+in, SinOsc.ar(4.24, 0.5, 3), 0, 0.5); // subtle modulating shift
	OffsetOut.ar(0, Limiter.ar(snd2 + snd * 0.5, 1, 0.005) ! 2);
}).add;
)
