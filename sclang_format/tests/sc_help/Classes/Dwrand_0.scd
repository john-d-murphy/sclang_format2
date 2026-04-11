// Source: Classes/Dwrand.schelp block 0
(
{
	var a, freq, trig;
	a = Dwrand([0, 1, 2, 7], [0.4, 0.4, 0.1, 0.1], inf).dpoll;
	trig = Impulse.kr(MouseX.kr(1, 400, 1));
	freq = Demand.kr(trig, 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1

}.play;
)
