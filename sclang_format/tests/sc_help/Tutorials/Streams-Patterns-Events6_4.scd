// Source: Tutorials/Streams-Patterns-Events6.schelp block 4
(
// beat stretching using Pstretch
var pattern;

// define the basic pattern
pattern = Pbind(
	\dur, 0.15,
	\degree, Pseq([ Pshuf(#[-7,-3,0,2,4,7], 4), Pseq([0,1,2,3,4,5,6,7]) ], 1)
);

Pseq([
	pattern,		// normal
	Pstretch(0.5, pattern),	// stretch durations by a factor of 1/2
	Pstretch(2.0, pattern)	// stretch durations by a factor of 2
], inf).play
)
