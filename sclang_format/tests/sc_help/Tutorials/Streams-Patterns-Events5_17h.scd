// Source: Tutorials/Streams-Patterns-Events5.schelp block 17 (part 8/8)
(
// composing in non 12 equal temperaments. 72 tone equal temp.
Pbind(
	\stepsPerOctave, 72,
	\note, Pseq([
			// 1/1, 7/6, 3/2, 7/4, 9/8
		Pseq([ [0,16,42,58,84], Pseq([ 0, 16, 42, 58, 72, 84 ], 2), [0,16,42,58,84] ], 1),
			// 1/1, 6/5, 3/2, 9/5, 9/8
		Pseq([ [0,19,42,61,84], Pseq([ 0, 19, 42, 61, 72, 84 ], 2), [0,19,42,61,84] ], 1),
			// 1/1, 5/4, 3/2, 15/8, 9/8
		Pseq([ [0,23,42,65,84], Pseq([ 0, 23, 42, 65, 72, 84 ], 2), [0,23,42,65,84] ], 1),
			// 1/1, 9/7, 3/2, 27/14, 9/8
		Pseq([ [0,26,42,68,84], Pseq([ 0, 26, 42, 68, 72, 84 ], 2), [0,26,42,68,84] ], 1)
		], inf),
	\dur, Pseq([ 1.2, Pseq([0.15], 12), 1.2], inf)
).play
)
