// Source: Reference/play.schelp block 6 (part 1/3)
(
x = SynthDef(\test, { arg out, amp=0.1;
	var sound;
	sound = PinkNoise.ar(amp * [1,1]);
	Out.ar(out, sound);
}).play;
)
