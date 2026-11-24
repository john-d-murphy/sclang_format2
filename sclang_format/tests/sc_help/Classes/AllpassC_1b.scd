// Source: Classes/AllpassC.schelp block 1 (part 2/5)
(
{
	z = WhiteNoise.ar(0.2);
	z + AllpassN.ar(z, 0.01, XLine.kr(0.0001, 0.01, 20), 0.2)
}.play)
