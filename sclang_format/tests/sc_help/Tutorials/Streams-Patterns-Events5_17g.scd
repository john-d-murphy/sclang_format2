// Source: Tutorials/Streams-Patterns-Events5.schelp block 17 (part 7/8)
(
// chords. If an Array of pitches is returned by a Stream for pitch, then a chord
// will be played.
Pbind(
	\dur, 0.15,
	\degree, Pseq([
		Pshuf(#[-7,-3,0,2,4,7], 4)+[0,4],
		Pseq( [0,1,2,3,4,5,6,7] )+[0,2]
	], inf)
).play
)
