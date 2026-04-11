// Source: Classes/Ndef.schelp block 12 (part 1/24)
(
SynthDef(\grain, { |out=0, freq=300, amp=0.3|
	OffsetOut.ar(out, Pulse.ar(freq) * EnvGen.kr(Env.perc, doneAction: Done.freeSelf) * amp)
}).add;
)
