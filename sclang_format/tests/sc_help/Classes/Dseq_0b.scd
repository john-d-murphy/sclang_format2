// Source: Classes/Dseq.schelp block 0 (part 2/2)
(
{
	var a, freq, trig;
	a = Dseq({ 10.rand } ! 32, inf);
	trig = Impulse.ar(MouseX.kr(1, 10000, 1));
	freq = Demand.ar(trig, 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1

}.play;
)
