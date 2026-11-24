// Source: Classes/Group.schelp block 2 (part 16/19)
(
3.do({
	// random freq for each synth, added to g at the head
	Synth("help-Group-moto-rev", ["out", 0, "freq", rrand(10, 1200)], g, \addToHead);
});
)
