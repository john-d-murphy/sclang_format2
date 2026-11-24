// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 1/45)
(
s.boot;

SynthDef(\pgrain,
	{ arg out = 0, freq=800, sustain=0.001, amp=0.5, pan = 0;
		var window;
		window = Env.sine(sustain, amp * AmpCompA.kr(freq));
		Out.ar(out,
			Pan2.ar(
				SinOsc.ar(freq),
				pan
			) * EnvGen.ar(window, doneAction: Done.freeSelf)
		)
	}
).add;

SynthDef(\noiseGrain,
	{ arg out = 0, freq=800, sustain=0.001, amp=0.5, pan = 0;
		var window;
		window = Env.perc(0.002, sustain, amp * AmpCompA.kr(freq));
		Out.ar(out,
			Pan2.ar(
				Ringz.ar(PinkNoise.ar(0.1), freq, 2.6),
				pan
			) * EnvGen.ar(window, doneAction: Done.freeSelf)
		)
	}
).add;



Pdef(\sweep, { arg sustain=1, n=8, freq=440, ratio=0.1;
	Pbind(
		\instrument, \pgrain,
		\dur, sustain.value / n,
		\freq, Pseq((1..n)) * ratio + 1 * freq.value // freq is a function, has to be evaluated
	)
});
Pdef(\sweep2, { arg sustain=1, n=8, freq=440, ratio=0.1;
	Pbind(
		\instrument, \noiseGrain,
		\dur, sustain.value / n, // sustain is also a function, has to be evaluated
		\freq, Pseq((1..n).scramble) * ratio + 1 * freq.value,
		\recursionLevel, 2
	)
});
Pdef(\sweep3, { arg freq=440;
	Pbind(
		\type, \phrase,
		\instrument, \sweep,
		\freq, Pfunc({ rrand(0.8, 1.3) }) * freq.value,
		\dur, 0.3,
		\legato, 1.3,
		\n, 5
	)
});
)
