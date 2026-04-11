// Source: Classes/FOS.schelp block 1 (part 2/3)
(
// same as OneZero
{	var x;
	x = LFTri.ar(0.4, 0, 0.99);
	FOS.ar(LFSaw.ar(200, 0, 0.2), 1 - x.abs, x, 0.0)
}.play;
)
