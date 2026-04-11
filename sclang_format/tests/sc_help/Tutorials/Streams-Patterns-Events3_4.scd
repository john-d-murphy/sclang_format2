// Source: Tutorials/Streams-Patterns-Events3.schelp block 4
(
var a, d;
a = Pseq(#[60, 61, 63, 65, 67, 63], inf ).asStream.midicps;
d = 0.3;
Task({
	12.do({
		Synth(\help_SPE3_SimpleSine, [ \freq, a.next, \sustain, d ]);
		d.wait;
	});
}).play
)
