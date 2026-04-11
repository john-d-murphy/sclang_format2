// Source: Guides/Debugging-tips.schelp block 29 (part 2/3)
r = Routine({
	loop {
		a.do({ |item| item.yield });
	}
});
