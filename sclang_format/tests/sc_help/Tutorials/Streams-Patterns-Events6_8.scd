// Source: Tutorials/Streams-Patterns-Events6.schelp block 8
(
var pattern;
pattern = Pbind( \midinote, Pseq(#[60, 62, 64, 65, 67, 69, 71, 72]) );

Pseq([
	Pbindf(pattern, \legato, 0.1, \dur, 0.2),
	Pbindf(pattern, \legato, 1.0, \dur, 0.125),
	Pbindf(pattern, \legato, 2.0, \dur, 0.3)
], inf).play
)
