// Source: Classes/Pbrown.schelp block 1 (part 3/3)
(
var a, x, f;
a = Pbrown(0.0, 1.0, 0.1, inf);

f = { |pattern, dt=0.02, min=300, max=900|
	{
		var x = pattern.asStream;
		loop {
			Synth.grain(\help_sinegrain, [\freq, x.next.linexp(0, 1, min, max), \sustain, dt]);
			dt.wait;
		}
	}.fork;
}.flop;

// 3 parallel motions
f.(a, [0.02, 0.08, 0.16]);
)
