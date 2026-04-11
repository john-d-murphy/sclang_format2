// Source: Tutorials/Streams-Patterns-Events6.schelp block 7 (part 2/3)
(
// chromatic transposition
var pattern;

// define the basic pattern
pattern = Pbind(
	\dur, 0.1,
	\degree, Pseq([0,1,2,3,4,5,6,7])
);

Paddp(
	\ctranspose,		// property to be modified
	Pseries(0,1,12),	// a value pattern as a source of values for multiplying with ctranspose
	pattern			// the pattern to be modified
).play
)
