// Source: Tutorials/Streams-Patterns-Events3.schelp block 9
(
var a;
a = Pxrand(#[60, 61, 63, 65], inf).midicps.asStream;
Task({
	12.do({
		Synth(\help_SPE3_SimpleSine, [\freq, a.next]);
		0.8.wait;
	});
}).play;
)
