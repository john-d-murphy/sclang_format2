// Source: Tutorials/A-Practical-Guide/PG_Cookbook07_Rhythmic_Variations.schelp block 1 (part 4/4)
t.schedAbs(t.nextTimeOnGrid(4, -0.001), {
	[~kik, ~snr, ~hh].do(_.stop);
});
