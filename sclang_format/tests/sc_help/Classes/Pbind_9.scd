// Source: Classes/Pbind.schelp block 9
(
// the SynthDef
SynthDef(\test, { |out, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1|
	var audio = Blip.ar(freq, nharms, amp);
	var env = Linen.kr(gate, doneAction: Done.freeSelf);
	OffsetOut.ar(out, Pan2.ar(audio, pan, env));
}).add;

// Events are written as parantheses enclosing key/value pairs
(instrument: \test).play;
(instrument: \test, freq: 20, nharms: 50).play;
)
