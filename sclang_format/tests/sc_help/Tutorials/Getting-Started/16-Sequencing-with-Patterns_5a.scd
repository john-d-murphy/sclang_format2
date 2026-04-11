// Source: Tutorials/Getting-Started/16-Sequencing-with-Patterns.schelp block 5 (part 1/2)
(
SynthDef(\smooth, { |out, freq = 440, sustain = 1, amp = 0.5|
	var sig;
	sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: Done.freeSelf);
	Out.ar(out, sig ! 2)
}).add;
)
