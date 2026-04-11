// Source: Tutorials/Streams-Patterns-Events5.schelp block 17 (part 5/8)
(
// chromatic transposition
var notes;
notes = Pseq([ Pshuf(#[-7,-3,0,2,4,7], 4), Pseq([0,1,2,3,4,5,6,7]) ], 1);
Pseq([
	Pbind(
		\dur, 0.15,
		\ctranspose, 0,
		\degree, notes
	),
	Pbind(
		\dur, 0.15,
		\ctranspose, 3,
		\degree, notes
	),
	Pbind(
		\dur, 0.15,
		\ctranspose, -3,
		\degree, notes
	)
], inf).play
)
