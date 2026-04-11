// Source: Classes/Dxrand.schelp block 0
(
{
	var a, freq, trig;
	a = Dxrand([1, 3, 2, 7, 8], inf);
	trig = Impulse.kr(MouseX.kr(1, 400, 1));
	freq = Demand.kr(trig, 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1

}.play;
)
