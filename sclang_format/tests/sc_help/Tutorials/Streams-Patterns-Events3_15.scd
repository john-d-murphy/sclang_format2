// Source: Tutorials/Streams-Patterns-Events3.schelp block 15
(
var a, b;
a = Pseq(#[60, 62, 63, 65, 67, 63]);
b = Pseq([ a, a + 7, a + 5], inf).asStream;
Task({
	24.do({
		Synth(\help_SPE3_SimpleSine, [ \freq, b.next.midicps ]);
		0.3.wait;
	});
}).play;
)
