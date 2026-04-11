// Source: Tutorials/A-Practical-Guide/PG_Ref01_Pattern_Internals.schelp block 7 (part 1/3)
r = Routine({ |inval|
	loop {
			// here is where the 2nd, 3rd, 4th etc. input values come in
		inval = yield(inval * 2);
	}
});
