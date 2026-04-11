// Source: Classes/Dbrown.schelp block 0
(
{
	var a, freq, trig;
	a = Dbrown(0, 15, 1, inf);
	trig = Impulse.kr(MouseX.kr(1, 40, 1));
	freq = Demand.kr(trig, 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1

}.play;
)
