// Source: Guides/Understanding-Errors.schelp block 1 (part 1/15)
Routine({
	var a;
	a = 5;
	loop {
		var b;
		b = 20.rand;
		b.postln.ecky_ecky_phtang;   // "NI!!!!"
		a.wait;
	}
}).play;
