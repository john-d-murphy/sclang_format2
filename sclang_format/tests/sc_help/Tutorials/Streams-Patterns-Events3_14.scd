// Source: Tutorials/Streams-Patterns-Events3.schelp block 14
(
var a;
a = Prand([
		Pseq(#[60, 61, 63, 65, 67, 63]),
		Prand(#[72, 73, 75, 77, 79], 6),
		Pshuf(#[48, 53, 55, 58], 2)
	], inf
).midicps.asStream;
Task({
	loop({
		Synth( \help_SPE3_SimpleSine, [\freq, a.next] );
		0.3.wait;
	});
}).play;
)
