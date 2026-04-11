// Source: Tutorials/Streams-Patterns-Events3.schelp block 7
(
var a, d;
a = Prand(#[60, 61, 63, 65], inf).midicps.asStream;
d = 0.3;
Task({
	12.do({
		Synth(\help_SPE3_SimpleSine,[\freq, a.next]);
		d.wait;
	});
}).play;
)
