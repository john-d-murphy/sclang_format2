// Source: Classes/Schmidt.schelp block 1 (part 4/4)
(
{
	var in = LFNoise1.kr(3);
	var octave = Schmidt.kr(in, -0.15, 0.15) + 1;
	SinOsc.ar(in * 200 + 500 * octave, 0, 0.1)
}.scope;
)
