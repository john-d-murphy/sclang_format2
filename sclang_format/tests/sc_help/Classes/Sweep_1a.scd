// Source: Classes/Sweep.schelp block 1 (part 1/13)
(
SynthDef(\lineReset, { |out, start = 0, end = 1, dur = 1, t_trig = 1, run = 1|
	var phasor = Sweep.ar(t_trig, run / dur).linlin(0, 1, start, end, \minmax);
	phasor.poll;
	Out.ar(out, SinOsc.ar(phasor, 0, 0.2));
}).add;
)
