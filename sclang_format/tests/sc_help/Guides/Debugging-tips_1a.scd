// Source: Guides/Debugging-tips.schelp block 1 (part 1/5)
{	var	freq;
	freq = LFNoise1.kr(2, 600, 800);
		// Impulse is needed to trigger the /tr message to be sent
	SendTrig.kr(Impulse.kr(4), 0, freq);
	SinOsc.ar(freq, 0, 0.3) ! 2
}.play;
