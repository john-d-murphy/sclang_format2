// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/15.schelp block 9
(
r = Routine({

	var array;
	array = [ "hello, world", "what a world", "i am a world" ];

	3.do({ 1.wait; array.choose.postln })

});
)
