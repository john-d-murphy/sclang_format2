// Source: Tutorials/Streams-Patterns-Events2.schelp block 10 (part 2/2)
(
// streams as a sequence of pitches
	var pattern, streams, dur, durDiff;
	dur = 1/7;
	durDiff = 3;
	pattern = Prout.new({
		loop({
			if (0.5.coin, {
				#[ 24,31,36,43,48,55 ].do({ arg fifth; fifth.yield });
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
	streams = [
		(pattern - Pfunc.new({ #[12, 7, 7, 0].choose })).midicps.asStream,
		pattern.midicps.asStream
	];
	Routine({
		loop({
			Synth( \help_SPE2, [ \freq, streams.at(0).next, \sustain, dur * durDiff ] );
			durDiff.do({
				Synth( \help_SPE2, [ \freq, streams.at(1).next, \sustain, dur ] );
				dur.wait;
			});
		})
	}).play
)
