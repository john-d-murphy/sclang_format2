// Source: Reference/Control-Structures.schelp block 9 (part 7/7)
Routine {
	var i = 10;
	while { i > 0 } {
		i.yield;
		i = i - 5.0.rand
	}
}.do { arg item; item.postln };
