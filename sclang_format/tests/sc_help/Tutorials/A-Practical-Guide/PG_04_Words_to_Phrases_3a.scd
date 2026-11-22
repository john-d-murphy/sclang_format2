// Source: Tutorials/A-Practical-Guide/PG_04_Words_to_Phrases.schelp block 3 (part 1/2)
(
~phrases = (
	repeated: Pbind(
		\instrument, \bass,
		\midinote, 36,
		\dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
		\legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
		\amp, 0.5, \detune, 1.005
	),
	octave: Pmono(\bass,
		\midinote, Pseq([36, 48, 36], 1),
		\dur, Pseq([0.25, 0.25, 0.5], 1),
		\amp, 0.5, \detune, 1.005
	),
	tritone: Pmono(\bass,
		\midinote, Pseq([36, 42, 41, 33], 1),
		\dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
		\amp, 0.5, \detune, 1.005
	),
	dim: Pmono(\bass,
		\midinote, Pseq([36, 39, 36, 42], 1),
		\dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
		\amp, 0.5, \detune, 1.005
	)
);

TempoClock.default.tempo = 128/60;

// the higher level control pattern is really simple now
p = Psym(Pxrand(#[repeated, octave, tritone, dim], inf), ~phrases).play;
)
