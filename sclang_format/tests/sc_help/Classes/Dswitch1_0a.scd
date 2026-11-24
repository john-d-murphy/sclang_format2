// Source: Classes/Dswitch1.schelp block 0 (part 1/2)
(
{
	var a, freq, trig;
	a = Dswitch1([1, 3, MouseY.kr(1, 15), 2, Dwhite(0, 3, 2)], MouseX.kr(0, 4));
	trig = Impulse.kr(3);
	freq = Demand.kr(trig, 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1

}.play;
)
