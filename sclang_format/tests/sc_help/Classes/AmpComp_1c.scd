// Source: Classes/AmpComp.schelp block 1 (part 3/15)
(
{
	var freq;
	freq = MouseX.kr(300, 15000, 1);
	Pulse.ar(freq) * 0.1 * AmpComp.kr(freq, 300, 1.3)
}.play;
)
