// Source: Classes/MIDIIn.schelp block 4 (part 2/12)
(
SynthDef("moto-rev", { |out, ffreq = 100|
	var x;
	x = RLPF.ar(
		LFPulse.ar(
			SinOsc.kr(0.2, 0, 10, 21),
			[0, 0.1],
			0.1
		),
		ffreq, 0.1
	).clip2(0.4);
	Out.ar(out, x);
}).add;
)
