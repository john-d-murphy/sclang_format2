// Source: Classes/Pget.schelp block 0
(
	/*

	Two patterns playing in parallel, 
	sharing data between eachother

	*/

	// a melody playing random scale degrees
	a = Pbind(
		\dur, 0.125, 
		\octave, 4,
		\degree, Plet(\melody, pattern: Pwhite(0,7))
	);

	// the bass, scale degrees sampled from the \melody variable defined above 
	b = Pbind(
		\dur, 0.5, 
		\octave, 3,
		\degree, Pget(\melody, default: 1, repeats: inf).trace
	);

	// Play the patterns in parallel
	Plambda(
		Ppar([a, b], inf)
	).play;
)
