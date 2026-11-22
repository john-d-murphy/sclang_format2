// Source: Classes/TGrains.schelp block 1 (part 12/13)
(
{
	var trate, dur, z, d;
	trate = MouseX.kr(1, 100, 1);
	d = { Dwhite(0.1, 0.2, 1) };
	z = {
		Drand([Dgeom(0.1, 1 + d.value, Diwhite(20, 40)), Dgeom(1, 1 - d.value, Diwhite(20, 40))])
	};
	TGrains.ar(2,
		Impulse.ar(trate),
		bufnum: 10,
		rate: Dseq([1, 1, z.value, 0.5, 0.5, 0.2, 0.1, 0.1, 0.1, 0.1], inf) * 2 + 1,
		centerPos: Dseq(z.dup(8), inf),
		dur: Dseq([1, d.value, 1, z.value, 0.5, 0.5, 0.1, z.value] * 2, inf) / trate,
		pan: Dseq([1, 1, 1, 0.5, 0.2, 0.1, 0, 0, 0], inf) * 2 - 1,
		amp: Dseq([1, 0, z.value, 0, 2, 1.0, 1, 0.1, 0.1], inf)
	);
}.scope(zoom: 4);
)
