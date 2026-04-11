// Source: Classes/Formlet.schelp block 1 (part 4/5)
(
// mouse control of frequency and decay time.
{
	var in;
	in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1);
	Formlet.ar(in,
		MouseY.kr(700,2000,1),
		0.005, MouseX.kr(0.01,0.2,1));
}.play;
)
