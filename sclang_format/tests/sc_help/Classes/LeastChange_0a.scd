// Source: Classes/LeastChange.schelp block 0 (part 1/5)
(
d = { arg amp=1.0;
	var in1, in2;
	in1 = LFNoise0.ar(800, amp);
	in2 = SinOsc.ar(800);
	LeastChange.ar(in1, in2) * 0.1;
}.play;
)
