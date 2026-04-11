// Source: Classes/NodeMap.schelp block 1 (part 2/13)
(
SynthDef("modsine",
	{ | out, freq=320, amp=0.2 |
		Out.ar(out, SinOsc.ar(freq, 0, amp));
	}).add;
SynthDef("lfo",
	{ | out, rate=2 |
		Out.kr(out, LFPulse.kr(rate, 0, 0.1, 0.2))
	}).add;
)
