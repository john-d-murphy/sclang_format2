// Source: Tutorials/Streams-Patterns-Events1.schelp block 10 (part 2/2)
(
// streams as a sequence of pitches
	var stream, dur;
	dur = 1/8;
	stream = Routine.new({
		loop({
			if (0.5.coin, {
				// run of fifths:
				24.yield;
				31.yield;
				36.yield;
				43.yield;
				48.yield;
				55.yield;
			});
			rrand(2,5).do({
				// varying arpeggio
				60.yield;
				#[63,65].choose.yield;
				67.yield;
				#[70,72,74].choose.yield;
			});
			// random high melody
			rrand(3,9).do({ #[74,75,77,79,81].choose.yield });
		});
	});
	Routine({
		loop({
			Synth(\help_SPE1, [ \freq, stream.next.midicps ] );
			dur.wait; // synonym for yield, used by .play to schedule next occurrence
		})
	}).play
)
