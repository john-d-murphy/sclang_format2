// Source: Tutorials/Streams-Patterns-Events6.schelp block 2
(
var makePattern, durpat;

durpat = Pseq([ Pgeom(0.05, 1.1, 24), Pgeom(0.5, 0.909, 24) ], 2);

makePattern = { arg note, db, pan;
	Pbind( \dur, durpat, \db, db, \pan, pan, \midinote, Pseq([note, note-4], inf) );
};

Ptpar([
	{ 0.0 }, makePattern.value(53, -20, -0.9),
	{ 8.0.rand }, makePattern.value(60, -23, -0.3),
	{ 8.0.rand }, makePattern.value(67, -26,  0.3),
	{ 8.0.rand }, makePattern.value(74, -29,  0.9)
], inf).play;
)
