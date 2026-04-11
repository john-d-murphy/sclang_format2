// Source: Guides/Debugging-tips.schelp block 33 (part 2/6)
r = Routine({
	loop {
		"debugging".postln;	// looks like regular code, doesn't stand out
		a.do({ |item| item.yield });
	}
});
