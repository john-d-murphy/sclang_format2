// Source: Classes/AmpCompA.schelp block 1 (part 2/11)
(
{
	var freq;
	freq = MouseX.kr(300, 15000, 1);
	SinOsc.ar(freq) * 0.3 * AmpCompA.kr(freq)
}.play;
)
