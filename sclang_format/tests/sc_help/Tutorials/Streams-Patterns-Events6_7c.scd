// Source: Tutorials/Streams-Patterns-Events6.schelp block 7 (part 3/3)
(
// beat time stretching
var pattern;

// define the basic pattern
pattern = Pbind(
	\dur, 0.1,
	\degree, Pseq([0,1,2,3,4,5,6,7])
);

Pstretchp(
	Pseq([1,2,3], inf),	// a value pattern as a source of values for multiplying with stretch
	pattern			// the pattern to be modified
).play
)
