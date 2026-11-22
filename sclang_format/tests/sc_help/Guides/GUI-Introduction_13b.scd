// Source: Guides/GUI-Introduction.schelp block 13 (part 2/2)
Routine{
	20.do{
	{w.bounds=Rect(200.rand, 200+200.rand, 300,300) }.defer; // you must defer this
	0.1.wait;
	};
	{w.close}.defer; // you must defer this
}.play(SystemClock)
