// Source: Tutorials/A-Practical-Guide/PG_06g_Data_Sharing.schelp block 6 (part 1/3)
f = { |topNote, triad|
	var	x;
	x = (topNote - triad).debug("initial transposition steps");
	x = (x div: 7).debug("octaves to transpose");
	x = (x * 7).debug("steps to transpose");
	x + triad
};
