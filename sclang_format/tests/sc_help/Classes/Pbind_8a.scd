// Source: Classes/Pbind.schelp block 8 (part 1/2)
(
SynthDef(\acid, { arg out, freq = 1000, gate = 1, pan = 1, cut = 4000, rez = 0.8, amp = 1;
	Out.ar(out,
		Pan2.ar(
			RLPF.ar(
				Pulse.ar(freq, 0.05),
			cut, rez),
		pan) * EnvGen.kr(Env.linen(0.01, 1, 0.3), gate, amp, doneAction: Done.freeSelf);
	)
}).add;
)
