// Source: Reference/Assignment.schelp block 3
(
{
	var sig;
	sig = SinOsc.ar(LFNoise0.kr(10).exprange(1, 1000));
	sig = SinOsc.ar(310, sig * 3);
	sig = SinOsc.ar(230, sig * 0.4);
	sig * 0.2
}.play
)
