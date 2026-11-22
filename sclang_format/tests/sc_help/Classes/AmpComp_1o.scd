// Source: Classes/AmpComp.schelp block 1 (part 15/15)
(
SynthDef("pgrain",
	{ |out = 0, sustain = 0.01, amp = 0.5, pan = 0|
		var freq = MouseX.kr(300, 7000, 1);
		var window = Env.sine(sustain, amp * AmpCompA.ir(freq));
		Out.ar(out,
			Pan2.ar(
				SinOsc.ar(freq),
				pan
			) * EnvGen.ar(window, doneAction: Done.freeSelf)
		)
	}
).add;
)
