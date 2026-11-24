// Source: Classes/Monitor.schelp block 2 (part 4/5)
(
x.playN(
	[0, [1, 3, 2], 4], 		// outs can be nested: 87 -> 0, 88 -> [1, 3, 2], 89 -> 4
	[0.1, [0.4, 0.2, 0.1], 0.3],	// with nested volumes 0.1, [0.4, 0.2, 0.1], and 0.3
	[87, 88, 89]); 			// reading from these ins
)
