// Source: Classes/Dshuf.schelp block 0 (part 3/3)
(
{
	var a, freq, trig;
	a = Dseq([Dshuf([Drand([1, 2, 3], 1), 3, Drand([20, 23, 56], 1), 7, 8.5], 8)], inf);
	trig = Impulse.kr(MouseX.kr(1, 40, 1));
	freq = Demand.kr(trig, 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1

}.play;
)
