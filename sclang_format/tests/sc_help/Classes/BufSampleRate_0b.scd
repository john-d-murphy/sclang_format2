// Source: Classes/BufSampleRate.schelp block 0 (part 2/3)
(
{
	var freq;
	freq = [ BufSampleRate.kr(b) * 0.1, 1100];
	SinOsc.ar(freq, 0, 0.1)
}.play;
)
