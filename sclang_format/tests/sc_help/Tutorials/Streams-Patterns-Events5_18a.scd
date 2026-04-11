// Source: Tutorials/Streams-Patterns-Events5.schelp block 18 (part 1/2)
(
// changing duration
Pbind(
	\dur, Pseq([ Pgeom(0.05, 1.1, 24), Pgeom(0.5, 0.909, 24) ], inf),
	\midinote, Pseq(#[60, 58], inf)
).play
)
