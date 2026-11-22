// Source: Classes/Scale.schelp block 17
Pbind(
	\degree, Pseq((0..7), inf), // your melody goes here
	\scale, Scale.major, // your scale goes here
	\root, -3 // semitones relative to 60.midicps, so this is A
).play;
