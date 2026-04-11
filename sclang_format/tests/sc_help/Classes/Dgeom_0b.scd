// Source: Classes/Dgeom.schelp block 0 (part 2/2)
(
{
	var a, freq, trig;
	a = Dgeom(1, 1.2, inf);
	trig = Dust.kr(MouseX.kr(1, 40, 1));
	freq = Demand.kr(trig, 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1

}.play;
)
