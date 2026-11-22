// Source: Classes/AmpComp.schelp block 1 (part 2/15)
(
{
	var freq;
	freq = MouseX.kr(300, 15000, 1);
	SinOsc.ar(freq) * 0.1 * AmpComp.kr(freq, 300)
}.play;
)
