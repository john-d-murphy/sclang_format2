// Source: Classes/FOS.schelp block 1 (part 1/3)
(
// same as OnePole
{	var x;
	x = LFTri.ar(0.4, 0, 0.99);
	FOS.ar(LFSaw.ar(200, 0, 0.2), 1 - x.abs, 0.0, x)
}.play;
)
