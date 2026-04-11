// Source: Tutorials/Getting-Started/16-Sequencing-with-Patterns.schelp block 2
(
var midi, dur;
midi = Pseq([60, 72, 71, 67, 69, 71, 72, 60, 69, 67], 1).asStream;
dur = Pseq([2, 2, 1, 0.5, 0.5, 1, 1, 2, 2, 3], 1).asStream;

SynthDef(\smooth, { |out, freq = 440, sustain = 1, amp = 0.5|
	var sig;
	sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: Done.freeSelf);
	Out.ar(out, sig ! 2)
}).add;

r = Task({
	var delta;
	while {
		delta = dur.next;
		delta.notNil
	} {
		Synth(\smooth, [freq: midi.next.midicps, sustain: delta]);
		delta.yield;
	}
}).play(quant: TempoClock.default.beats + 1.0);
)
