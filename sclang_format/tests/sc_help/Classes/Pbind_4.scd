// Source: Classes/Pbind.schelp block 4
SynthDef(\test, { | out, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1 |
	var audio = Blip.ar(freq, nharms, amp);
	var env = Linen.kr(gate, doneAction: Done.freeSelf);
	OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
}).add;
