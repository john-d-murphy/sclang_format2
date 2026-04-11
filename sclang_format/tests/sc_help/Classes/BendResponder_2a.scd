// Source: Classes/BendResponder.schelp block 2 (part 1/2)
(
	c = BendResponder({ |src,chan,val|
		[src,chan,val].postln;
		},
		nil, // any source
		(3..6), // only channels 3 - 6
		nil // any value
	)
)
