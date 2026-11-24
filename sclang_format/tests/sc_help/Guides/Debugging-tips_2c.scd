// Source: Guides/Debugging-tips.schelp block 2 (part 3/6)
a = {
	var	freq, amp;
	freq = LFNoise0.kr(8, 600, 800);
	amp = LFNoise1.kr(10, 0.5, 0.5);
		// Impulse is needed to trigger the reply to be sent
	SendReply.kr(Impulse.kr(4), '/freqAmp', [freq, amp]);
	SinOsc.ar(freq, 0, amp) ! 2
}.play;
