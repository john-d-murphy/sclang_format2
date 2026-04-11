// Source: Tutorials/Mark_Polishook_tutorial/19_Scheduling.schelp block 7
(
r = Routine({

	// setup code
	var array;
	array = [ "hello, world", "what a world", "i am a world" ];

	// the loop
	3.do({ array.choose.yield })

});
)
