// Source: Tutorials/Streams-Patterns-Events5.schelp block 17 (part 2/8)
(
// change the octave
Pbind(
	\dur, 0.15,
	\octave, 4,
	\degree, Pseq([ Pshuf(#[-7,-3,0,2,4,7], 4), Pseq([0,1,2,3,4,5,6,7]) ], inf)
).play
)
