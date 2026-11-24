// Source: Classes/AllpassL.schelp block 1 (part 3/5)
(
{
	z = WhiteNoise.ar(0.2);
	z + AllpassL.ar(z, 0.01, XLine.kr(0.0001, 0.01, 20), 0.2)
}.play)
