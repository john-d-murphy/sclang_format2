// Source: Classes/Pstep.schelp block 0 (part 9/9)
(
var a, b, x;
var times, levels;

SynthDef(\pgrain,
	{ |out = 0, freq = 800, sustain = 0.001, amp = 0.5, pan = 0|
		var window;
		window = Env.sine(sustain, amp);
		Out.ar(out,
			Pan2.ar(
				SinOsc.ar(freq) * EnvGen.ar(window, doneAction: Done.freeSelf),
				pan
			)
		)
	}
).add;

times = Pseq([3.4, 1, 0.2, 0.2, 0.2], inf);
levels = Pseq([0, 1, 2, 3, 4], inf);

a = Pstep(levels, times);
b = Pbind(\instrument, \pgrain, \octave, 7, \dur, 0.12, \degree, a);
x = times;

Ppar([b, Pset(\mtranspose, 2, b)]).play;

b.play;
r {
	var z = x.asStream; // direct times
	0.5.wait;
	loop {
		z.next.wait;
		s.makeBundle(0.2, {
			Synth(\pgrain, [\freq, 3000, \sustain, 0.01]); // signal tone
		})
	}
}.play(quant: 1)
)
