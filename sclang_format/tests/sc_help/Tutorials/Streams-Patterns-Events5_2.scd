// Source: Tutorials/Streams-Patterns-Events5.schelp block 2
(
// specifying the pitch in terms of midinote
// see also The pitch model below
Pbind(
	\dur, 0.125,
	\legato, 0.2,
	\midinote, Pseq(#[60, 62, 64, 65, 67, 69, 71, 72], inf)
).play
)
