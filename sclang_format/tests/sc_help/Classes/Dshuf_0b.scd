// Source: Classes/Dshuf.schelp block 0 (part 2/3)
(
{
	var a, freq, trig;
	a = Dseq([Dshuf({ 10.rand } ! 81, 5)], inf).poll;
	trig = Impulse.ar(MouseX.kr(1, 10000, 1));
	freq = Demand.ar(trig, 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1

}.play;
)
