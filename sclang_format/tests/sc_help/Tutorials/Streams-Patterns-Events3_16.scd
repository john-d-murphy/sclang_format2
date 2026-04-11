// Source: Tutorials/Streams-Patterns-Events3.schelp block 16
(
var a;
a = Pseq(#[60, 62, 63, 65, 67, 63], inf) + Pseq(#[0, 0, 0, 0, -12], inf);
a = a.asStream.midicps;
Task({
	25.do({
		Synth(\help_SPE3_SimpleSine, [\freq, a.next]);
		0.3.wait;
	});
}).play;
)
