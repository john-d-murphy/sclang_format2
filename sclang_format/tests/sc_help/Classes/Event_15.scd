// Source: Classes/Event.schelp block 15
(
SynthDef(\test, {
	| out = 0, amp = 0.01, freq = #[300,400,400], pan, gate = 1 |
	var audio, env;
	audio = Mix.ar(Pulse.ar(freq, 0.5));	// this is a mixture of three oscillators
	env = Linen.kr(gate, susLevel: amp , doneAction: Done.freeSelf);
	audio = audio * env;
	OffsetOut.ar(out, audio);
}).add;
)
