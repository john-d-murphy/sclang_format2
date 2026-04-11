// Source: Guides/Tour_of_UGens.schelp block 54
(
{
	var z;
	z = Decay.ar(Dust.ar(1,0.5), 0.1, WhiteNoise.ar);
	8.do { z = AllpassL.ar(z, 0.04, 0.04.rand, 2) };
	z
}.scope(1);
)
