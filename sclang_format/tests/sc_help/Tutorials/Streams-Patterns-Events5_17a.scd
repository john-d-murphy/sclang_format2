// Source: Tutorials/Streams-Patterns-Events5.schelp block 17 (part 1/8)
(
// a simple scale degree sequence
Pbind(
		// -7 is 8ve below, -3 is a 4th below,
		// 0 is root, 2 is 3rd above, 4 is 5th above, 7 is 8ve above.
	\degree, Pseq([ Pshuf(#[-7,-3,0,2,4,7], 4), Pseq([0,1,2,3,4,5,6,7]) ], inf),
	\dur, 0.15
).play
)
