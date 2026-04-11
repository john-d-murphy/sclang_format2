// Source: Tutorials/Streams-Patterns-Events5.schelp block 17 (part 3/8)
(
// change the scale
Pbind(
	\dur, 0.15,
	\scale, [0, 2, 3, 5, 7, 8, 10],
	\degree, Pseq([ Pshuf(#[-7,-3,0,2,4,7], 4), Pseq([0,1,2,3,4,5,6,7]) ], inf)
).play
)
