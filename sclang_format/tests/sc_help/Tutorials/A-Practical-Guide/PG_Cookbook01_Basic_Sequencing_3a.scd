// Source: Tutorials/A-Practical-Guide/PG_Cookbook01_Basic_Sequencing.schelp block 3 (part 1/4)
(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

SynthDef(\stretchedFragments, { |out, bufnum, start, time = 1, stretch = 1, amp = 1, attack = 0.01, decay = 0.05|
	var sig = PlayBuf.ar(1, bufnum, rate: stretch.reciprocal, startPos: start), eg;
	sig = PitchShift.ar(sig, pitchRatio: stretch);
	eg = EnvGen.kr(Env.linen(attack, time, decay), sig.abs > 0, doneAction: Done.freeSelf);
	Out.ar(out, (sig * eg) ! 2)
}).add; // note add! Without this, arguments won't work
)
