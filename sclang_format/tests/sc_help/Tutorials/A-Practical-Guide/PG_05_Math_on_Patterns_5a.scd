// Source: Tutorials/A-Practical-Guide/PG_05_Math_on_Patterns.schelp block 5 (part 1/3)
Pwhite(0, 255, 20).clump(4).do { |x| x.postln };

	// a two-dimensional array
Array.fill(5, { Array.fill(4, { rrand(1, 5) }) });
