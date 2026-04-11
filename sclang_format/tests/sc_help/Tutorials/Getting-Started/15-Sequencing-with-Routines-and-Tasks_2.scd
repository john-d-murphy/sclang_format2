// Source: Tutorials/Getting-Started/15-Sequencing-with-Routines-and-Tasks.schelp block 2
(
SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1, out|
	var sig;
	sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: Done.freeSelf);
	Out.ar(out, sig ! 2);	// sig ! 2 is the same as [sig, sig]
}).add;

r = Routine({
	var delta;
	loop {
		delta = rrand(1, 3) * 0.5;
		Synth(\singrain, [freq: exprand(200, 800), amp: rrand(0.1, 0.5), sustain: delta * 0.8]);
		delta.yield;
	}
});
)
