// Source: Tutorials/Streams-Patterns-Events5.schelp block 18 (part 2/2)
(
// changing legato value
Pbind(
	\dur, 0.2,
	\legato, Pseq([ Pseries(0.05, 0.05, 40), Pseries(2.05, -0.05, 40) ], inf),
	\midinote, Pseq(#[48, 51, 55, 58, 60, 58, 55, 51], inf)
).play
)
