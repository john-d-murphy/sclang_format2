// Source: Classes/Dseries.schelp block 0 (part 1/2)
(
{
	var a, freq, trig;
	a = Dseries(0, 1, 15);
	trig = Impulse.kr(MouseX.kr(1, 40, 1));
	freq = Demand.kr(trig, 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1

}.play;
)
