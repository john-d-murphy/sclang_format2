// Source: Tutorials/Streams-Patterns-Events3.schelp block 11
(
var a, b;
a = Pshuf(#[60, 61, 65, 67], inf).midicps.asStream;
Task({
	12.do({
		Synth(\help_SPE3_SimpleSine, [\freq, a.next]);
		0.5.wait;
	});
}).play;
)
