// Source: Classes/EnvGen.schelp block 9
(
a = Bus.control(s, 1);

Slider(nil, Rect(800, 200, 200, 25))
.action_({ |view| a.set(view.value.lincurve(0, 1, 0, 0.12, 4)) })
.front
.onClose_({ p.stop; a.free });

SynthDef(\test, { |out = 0, freq = 100, ffreq = 500, rq = 0.25, modFactor = 12, atk = 0, dcy = 0.12|
	// change to 'envInit = 0' to hear the short-attack artifacts
	// warning: envInit = 0 may be LOUD
	var envInit = atk.linlin(0, 0.05, 1, 0);
	var filtEg = EnvGen.kr(Env([envInit, 1, 0], [atk, dcy], -4));
	var ampEg = EnvGen.ar(Env.linen(0.001, 0.2, 0.1), doneAction: 2);
	var sig = Saw.ar(freq);
	ffreq = ffreq * (1 + (filtEg * modFactor));
	sig = BLowPass4.ar(sig, ffreq, rq) * ampEg;
	Out.ar(out, (sig * 0.1).dup)
}).add;

p = Pbind(
	\instrument, \test,
	\freq, 100,
	\atk, a.asMap
).play;
)
