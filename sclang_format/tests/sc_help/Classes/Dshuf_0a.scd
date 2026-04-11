// Source: Classes/Dshuf.schelp block 0 (part 1/3)
(
{
	var a, freq, trig;
	a = Dseq([Dshuf([1, 3, 2, 7, 8.5], 3)], inf);
	trig = Impulse.kr(MouseX.kr(1, 40, 1));
	freq = Demand.kr(trig, 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1

}.play;
)
