// Source: Tutorials/Getting-Started/16-Sequencing-with-Patterns.schelp block 5 (part 2/2)
(
p = Pbind(
		// the name of the SynthDef to use for each note
	\instrument, \smooth,
		// MIDI note numbers -- converted automatically to Hz
	\midinote, Pseq([60, 72, 71, 67, 69, 71, 72, 60, 69, 67], 1),
		// rhythmic values
	\dur, Pseq([2, 2, 1, 0.5, 0.5, 1, 1, 2, 2, 3], 1)
).play;
)
