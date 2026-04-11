// Source: Classes/ProgramChangeResponder.schelp block 1 (part 1/2)
(
	c = ProgramChangeResponder({ |src,chan,val|
		[src,chan,val].postln;
		},
		nil, // any source
		nil, // any channel
		(50..60) // within this value range
	)
)
