// Source: Classes/TGrains.schelp block 1 (part 11/13)
(
{
	var trate, dur;
	trate = MouseY.kr(2, 120, 1);
	dur = 1.2 / trate;
	TGrains.ar(2, Impulse.ar(trate), b, (1.2 ** WhiteNoise.kr(3).round(1)), MouseX.kr(0, BufDur.kr(b)), dur, WhiteNoise.kr(0.6), 0.1);
}.scope(zoom: 4);
)
