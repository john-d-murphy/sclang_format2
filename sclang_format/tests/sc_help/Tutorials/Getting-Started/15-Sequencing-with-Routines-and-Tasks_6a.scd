// Source: Tutorials/Getting-Started/15-Sequencing-with-Routines-and-Tasks.schelp block 6 (part 1/5)
(
f = {
	Task({
		loop {
			[60, 62, 64, 65, 67, 69, 71, 72].do({ |midi|
				Synth(\singrain, [freq: midi.midicps, amp: 0.2, sustain: 0.1]);
				0.25.wait;
			});
		}
	});
};
)
