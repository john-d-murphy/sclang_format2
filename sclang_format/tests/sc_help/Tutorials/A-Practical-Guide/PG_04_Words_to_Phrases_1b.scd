// Source: Tutorials/A-Practical-Guide/PG_04_Words_to_Phrases.schelp block 1 (part 2/3)
(
TempoClock.default.tempo = 132/60;
p = Pxrand([
	Pbind(			// repeated notes
		\instrument, \bass,
		\midinote, 36,
		\dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
		\legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
		\amp, 0.5, \detune, 1.005
	),
	Pmono(\bass,		// octave jump
		\midinote, Pseq([36, 48, 36], 1),
		\dur, Pseq([0.25, 0.25, 0.5], 1),
		\amp, 0.5, \detune, 1.005
	),
	Pmono(\bass,		// tritone jump
		\midinote, Pseq([36, 42, 41, 33], 1),
		\dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
		\amp, 0.5, \detune, 1.005
	),
	Pmono(\bass,		// diminished triad
		\midinote, Pseq([36, 39, 36, 42], 1),
		\dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
		\amp, 0.5, \detune, 1.005
	)
], inf).play(quant: 1);
)
