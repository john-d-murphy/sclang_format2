// Source: Classes/Dreset.schelp block 0 (part 1/3)
(
{
	var a, freq;
	a = Dreset(Dseries(0, 2, inf), Drand([0, 0, 0, 1], inf));
	freq = Duty.kr(1/MouseX.kr(1, 40, 1), 0, a) * 30 + 340;
	SinOsc.ar(freq) * 0.1
}.play;
)
