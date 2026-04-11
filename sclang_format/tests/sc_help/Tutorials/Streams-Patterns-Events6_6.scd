// Source: Tutorials/Streams-Patterns-Events6.schelp block 6
(
// modal transposition
var pat1, pat2;

// define the basic pattern
pat1 = Pbind(
	\dur, 0.15,
	\degree, Pseq([ Pshuf(#[-7,-3,0,2,4,7], 4), Pseq([0,1,2,3,4,5,6,7]) ], 1)
);

pat2 = Paddp(
	\mtranspose,	// property to be modified
	Pseq([0,1,2]),	// a value pattern as a source of values for adding to mtranspose
	Ppar([
		pat1,
		Padd(\mtranspose, -3, pat1),	// down a 4th
		Padd(\mtranspose, 2, pat1)	// up a 3rd
	])
);

Pseq([
	pat1,	// unmodified pattern
	pat2,	// parallel sequence
	Pstretch(1.5, pat2)	// parallel sequence stretched by 3/2
], inf).play
)
