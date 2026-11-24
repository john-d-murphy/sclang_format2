// Source: Tutorials/Getting-Started/16-Sequencing-with-Patterns.schelp block 6 (part 2/4)
(
SynthDef(\kik, { |out, preamp = 1, amp = 1|
	var freq = EnvGen.kr(Env([400, 66], [0.08], -3)),
		sig = SinOsc.ar(freq, 0.5pi, preamp).distort * amp
			* EnvGen.kr(Env([0, 1, 0.8, 0], [0.01, 0.1, 0.2]), doneAction: Done.freeSelf);
	Out.ar(out, sig ! 2);
}).add;

// before you play:
// what do you anticipate '\delta, 1' will do?
k = Pbind(\instrument, \kik, \delta, 1, \preamp, 4.5, \amp, 0.32).play(quant: 1);
)
