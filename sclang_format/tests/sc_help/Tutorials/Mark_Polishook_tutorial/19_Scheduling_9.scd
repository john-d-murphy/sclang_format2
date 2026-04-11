// Source: Tutorials/Mark_Polishook_tutorial/19_Scheduling.schelp block 9
(
r = Routine({

	var array;
	array = [ "hello, world", "what a world", "i am a world" ];

	3.do({
		1.wait; 		// pause for 1 second
		array.choose.postln;
	})

});
)
