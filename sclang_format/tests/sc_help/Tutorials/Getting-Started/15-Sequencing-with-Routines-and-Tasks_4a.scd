// Source: Tutorials/Getting-Started/15-Sequencing-with-Routines-and-Tasks.schelp block 4 (part 1/4)
(
t = Task({
	loop {
		[60, 62, 64, 65, 67, 69, 71, 72].do({ |midi|
			Synth(\singrain, [freq: midi.midicps, amp: 0.2, sustain: 0.1]);
			0.125.wait;
		});
	}
}).play;
)
