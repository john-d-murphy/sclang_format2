// Source: Classes/MostChange.schelp block 0 (part 1/10)
(
d = SynthDef("help-MostChange", { |out, amp = 1.0|
	var sound, in1, in2;
	in1 = LFNoise1.ar(800, amp);
	in2 = SinOsc.ar(800);
	sound = MostChange.ar(in1, in2) * 0.1;
	Out.ar(out, sound)
}).play;
)
