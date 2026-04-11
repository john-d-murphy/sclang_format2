// Source: Classes/T2A.schelp block 0 (part 3/3)
(
{
	var trig = Impulse.kr(MouseX.kr(1, 100, 1));
	Ringz.ar(T2A.ar(trig, WhiteNoise.kr.range(0, s.options.blockSize - 1)), 800, 0.01) * 0.4
}.play;
)
