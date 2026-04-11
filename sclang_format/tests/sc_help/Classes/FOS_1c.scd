// Source: Classes/FOS.schelp block 1 (part 3/3)
(
// same as OnePole, kr
{	var x, ctl;
	x = LFTri.kr(0.2, 0, 0.99);
	ctl = FOS.kr(LFSaw.kr(8, 0, 0.2), 1 - x.abs, 0.0, x);
	LFTri.ar(ctl * 200 + 500);
}.play;
)
