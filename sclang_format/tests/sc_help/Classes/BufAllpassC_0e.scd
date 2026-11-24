// Source: Classes/BufAllpassC.schelp block 0 (part 5/6)
(
{
	z = WhiteNoise.ar(0.2);
	z + BufAllpassC.ar(b.bufnum, z, XLine.kr(0.0001, 0.01, 20), 0.2)
}.play)
