// Source: Classes/SampleRate.schelp block 0
(
{
	var freq;
	freq = [SampleRate.ir * 0.01, 440];
	SinOsc.ar(freq, 0, 0.1)
}.play;
)
