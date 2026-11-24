// Source: Classes/BufAllpassN.schelp block 0 (part 4/6)
(
{
	z = WhiteNoise.ar(0.2);
	z + BufAllpassL.ar(b.bufnum, z, XLine.kr(0.0001, 0.01, 20), 0.2)
}.play)
