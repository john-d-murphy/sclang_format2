// Source: Tutorials/Streams-Patterns-Events6.schelp block 3
(
// modal transposition
var pattern;

// define the basic pattern
pattern = Pbind(
	\dur, 0.15,
	\degree, Pseq([ Pshuf(#[-7,-3,0,2,4,7], 4), Pseq([0,1,2,3,4,5,6,7]) ], 1)
);

Pseq([
	pattern,		// untransposed
	Padd(\mtranspose, 1, pattern),	// modal transpose up 1 degree
	Padd(\mtranspose, 2, pattern)	// modal transpose up 2 degrees
], inf).play
)
