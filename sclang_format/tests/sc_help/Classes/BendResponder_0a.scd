// Source: Classes/BendResponder.schelp block 0 (part 1/2)
(
c = BendResponder({ |src,chan,value|
		[src,chan,value].postln;
	});
	c.learn; // wait for the first bend message
)
