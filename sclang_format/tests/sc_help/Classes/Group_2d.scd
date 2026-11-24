// Source: Classes/Group.schelp block 2 (part 4/19)
(
l = Array.fill(3, {
	// random freq for each synth, added to g at the head
	Synth("help-Group-moto-rev", ["out", 0, "freq", rrand(10, 120)], g, \addToHead);
});
)
