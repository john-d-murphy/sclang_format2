// Source: Tutorials/Streams-Patterns-Events3.schelp block 17 (part 2/2)
(
var freqStream;

freqStream = Pseq([
	Prand([
		nil,	// a nil item reached in a pattern causes it to end
		Pseq(#[24, 31, 36, 43, 48, 55]);
	]),
	Pseq([ 60, Prand(#[63, 65]), 67, Prand(#[70, 72, 74]) ], { rrand(2, 5) }),
	Prand(#[74, 75, 77, 79, 81], { rrand(3, 9) })
], inf).asStream.midicps;

Task({
	loop({
		Synth( \help_SPE3_Allpass6, [\freq, freqStream.next ]);
		0.13.wait;
	});
}).play;
)
