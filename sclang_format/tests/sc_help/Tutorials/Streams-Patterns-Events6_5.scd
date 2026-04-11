// Source: Tutorials/Streams-Patterns-Events6.schelp block 5
(
// modal transposition
var pattern;

// define the basic pattern
pattern = Pbind(
	\dur, 0.15,
	\degree, Pseq([ Pshuf(#[-7,-3,0,2,4,7], 4), Pseq([0,1,2,3,4,5,6,7]) ], 1)
);

Paddp(
	\mtranspose,		// property to be modified
	Pseq([0,1,2], inf),	// a value pattern as a source of values for adding to mtranspose
	pattern			// the pattern to be modified
).play
)
