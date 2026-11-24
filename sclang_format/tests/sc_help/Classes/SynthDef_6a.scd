// Source: Classes/SynthDef.schelp block 6 (part 1/6)
(
SynthDef(\vartest, { |out, freq = 440, amp = 0.2, a = 0.01, r = 1|
	// the EnvGen with doneAction: Done.freeSelf frees the synth automatically when done
	Out.ar(out, SinOsc.ar(freq, 0, EnvGen.kr(Env.perc(a, r, amp), doneAction: Done.freeSelf)));
}, variants: (alpha: [a: 0.5, r: 0.5], beta: [a: 3, r: 0.01], gamma: [a: 0.01, r: 4])
).add;
)
