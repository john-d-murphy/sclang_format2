// Source: Classes/Bus.schelp block 3 (part 2/36)
(
// something to play with
SynthDef(\help_Bus, { arg out=0,ffreq=100;
	var x;
	x = RLPF.ar(LFPulse.ar(SinOsc.kr(0.2, 0, 10, 21), [0,0.1], 0.1),
			ffreq, 0.1)
			.clip2(0.4);
	Out.ar(out, x);
}).add;

)
