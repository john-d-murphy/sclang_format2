// Source: Tutorials/Streams-Patterns-Events6.schelp block 9
(
var pattern;
pattern = Pbind( \midinote, Pseq(#[60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79]) );

Pseq([
	Pbindf(pattern,\legato, 0.1, \dur, Pgeom(0.3, 0.85, inf)),
	Pbindf(pattern,\legato, 1.0, \dur, Pseq([0.3, 0.15], inf)),
	Pbindf(pattern,\legato, 2.0, \dur, Pseq([0.2, 0.2, 0.4], inf))
], inf).play
)
