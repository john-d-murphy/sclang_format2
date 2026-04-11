// Source: Classes/CCResponder.schelp block 2 (part 1/2)
(
	c = CCResponder({ |src,chan,num,value|
		[src,chan,num,value].postln;
		},
		nil, // any source
		nil, // any channel
		80, // CC number 80
		{ |val| val < 50 } // any value less than 50
	)
)
