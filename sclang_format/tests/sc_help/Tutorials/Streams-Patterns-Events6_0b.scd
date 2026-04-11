// Source: Tutorials/Streams-Patterns-Events6.schelp block 0 (part 2/2)
(
// Ppars can be nested
Ppar([
	Pbind(
		\dur, Prand([0.2, 0.4, 0.6], inf),
		\midinote, Prand([72, 74, 76, 77, 79, 81], inf),
		\db, -26,
		\legato, 1.1
	),
	Pseq([
		Pbind(\dur, 3.2, \freq, Pseq([\rest]) ),
		Prand([
			Ppar([
				Pbind(\dur, 0.2, \pan,  0.5, \midinote, Pseq([60, 64, 67, 64])),
				Pbind(\dur, 0.4, \pan, -0.5, \midinote, Pseq([48, 43]))
			]),
			Ppar([
				Pbind(\dur, 0.2, \pan,  0.5, \midinote, Pseq([62, 65, 69, 65])),
				Pbind(\dur, 0.4, \pan, -0.5, \midinote, Pseq([50, 45]))
			]),
			Ppar([
				Pbind(\dur, 0.2, \pan,  0.5, \midinote, Pseq([64, 67, 71, 67])),
				Pbind(\dur, 0.4, \pan, -0.5, \midinote, Pseq([52, 47]))
			])
		], 12)
	], inf)
], inf).play;
)
