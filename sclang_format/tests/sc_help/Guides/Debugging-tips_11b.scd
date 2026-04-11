// Source: Guides/Debugging-tips.schelp block 11 (part 2/5)
a = {
	var	freq;
	freq = LFNoise1.kr(2, 600, 800);
	Out.kr(b, freq);		// no need for Impulse here
	SinOsc.ar(freq, 0, 0.3) ! 2
}.play;

l = List.new;
