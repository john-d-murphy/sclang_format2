// Source: Classes/Dwhite.schelp block 0
(
{
	var a, freq, trig;
	a = Dwhite(0, 15, inf);
	trig = Impulse.kr(MouseX.kr(1, 40, 1));
	freq = Demand.kr(trig, 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1

}.play;
)
