// Source: Classes/TGrains.schelp block 1 (part 3/13)
(
{
	var trate, dur, rate;
	trate = MouseY.kr(2, 200, 1);
	dur = 4 / trate;
	rate = Dseq([10, 1, 1, 0.5, 0.5, 0.2, 0.1], inf);
	TGrains.ar(2, Impulse.ar(trate), b, rate, MouseX.kr(0, BufDur.kr(b)), dur, Dseq([-1, 1], inf), 0.1, 2);
}.scope(zoom: 4);
)
