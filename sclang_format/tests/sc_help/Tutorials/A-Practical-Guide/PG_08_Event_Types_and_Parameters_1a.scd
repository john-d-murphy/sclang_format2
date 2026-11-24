// Source: Tutorials/A-Practical-Guide/PG_08_Event_Types_and_Parameters.schelp block 1 (part 1/2)
p = Pbind(
		// array is "multichannel expanded" into one Synth each
	\degree, #[2, 5, 8, 11, 13, 16],
	\octave, 3,
	\dur, 2,
	\sustain, 3,
		// non-zero strum staggers the entrances
	\strum, 0.12
).play(quant: 2);
