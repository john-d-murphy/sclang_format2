// Source: Classes/Formlet.schelp block 1 (part 3/5)
(
// modulating formant frequency
{
	var in;
	in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1);
	Formlet.ar(in, XLine.kr(1500,700,8), 0.005, 0.04);
}.play;
)
