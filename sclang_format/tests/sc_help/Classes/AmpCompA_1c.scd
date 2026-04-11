// Source: Classes/AmpCompA.schelp block 1 (part 3/11)
(
{
	var freq;
	freq = MouseX.kr(300, 18000, 1);
	Formant.ar(300, freq, 20, 0.1) * AmpCompA.kr(freq, 300, 0.6, 0.3)
}.play;
)
