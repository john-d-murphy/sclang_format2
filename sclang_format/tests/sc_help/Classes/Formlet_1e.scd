// Source: Classes/Formlet.schelp block 1 (part 5/5)
(
// mouse control of frequency and decay time.
{
	var freq;
	freq = Formlet.kr(
		Dust.kr(10 ! 2),
		MouseY.kr(7,200,1),
		0.005, MouseX.kr(0.1,2,1)
	);
	SinOsc.ar(freq * 200 + [500, 600] - 100) * 0.2
}.play;
)
