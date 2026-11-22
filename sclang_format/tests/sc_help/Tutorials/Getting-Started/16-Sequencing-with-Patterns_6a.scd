// Source: Tutorials/Getting-Started/16-Sequencing-with-Patterns.schelp block 6 (part 1/4)
(
SynthDef(\bass, { |out, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
		detune = 1.005, preamp = 4|
	var sig, env;
	env = Env.adsr(0.01, 0.3, 0.4, 0.1);
	freq = Lag.kr(freq, slideTime);
	sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
		* EnvGen.kr(env, gate, doneAction: Done.freeSelf);
	sig = LPF.ar(sig, ffreq);
	Out.ar(out, sig ! 2)
}).add;

TempoClock.default.tempo = 132/60;

p = Pxrand([
	Pbind(
		\instrument, \bass,
		\midinote, 36,
		\dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
		\legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
		\amp, 0.5, \detune, 1.005
	),
	Pmono(\bass,
		\midinote, Pseq([36, 48, 36], 1),
		\dur, Pseq([0.25, 0.25, 0.5], 1),
		\amp, 0.5, \detune, 1.005
	),
	Pmono(\bass,
		\midinote, Pseq([36, 42, 41, 33], 1),
		\dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
		\amp, 0.5, \detune, 1.005
	),
	Pmono(\bass,
		\midinote, Pseq([36, 39, 36, 42], 1),
		\dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
		\amp, 0.5, \detune, 1.005
	)
], inf).play(quant: 1);
)
