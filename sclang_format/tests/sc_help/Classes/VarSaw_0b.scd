// Source: Classes/VarSaw.schelp block 0 (part 2/4)
(
play({
	VarSaw.ar(
		LFPulse.kr(3, 0, 0.3, 200, 200),
		0,
		LFTri.kr(1.0).range(0, 1), // width
		0.1)
});
)
