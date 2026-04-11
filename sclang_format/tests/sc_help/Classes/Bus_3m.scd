// Source: Classes/Bus.schelp block 3 (part 13/36)
(

SynthDef(\help_Bus, { |out|
	var ffreq = b.kr;
	Out.ar(out,
		RLPF.ar(
			LFPulse.ar(SinOsc.kr(0.2, 0, 10, 21), [0,0.1], 0.1),
			ffreq, 0.1
		).clip2(0.4)
	);
}).play;
)
