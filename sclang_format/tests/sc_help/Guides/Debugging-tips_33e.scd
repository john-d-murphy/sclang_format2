// Source: Guides/Debugging-tips.schelp block 33 (part 5/6)
r = Routine({
	loop {
"debugging".postln;	// this obviously sticks out
		a.do({ |item| item.yield });
	}
});
