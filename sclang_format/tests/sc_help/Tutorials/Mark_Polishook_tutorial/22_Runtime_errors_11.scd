// Source: Tutorials/Mark_Polishook_tutorial/22_Runtime_errors.schelp block 11
(
var a = 10;	// a is declared and initialized
var b;		// b declared but not initialized, so it defaults to nil

t = Task({

	4.do({ arg item, i;

		if(i != 3)
			{ i.postln } 		// print the value of i if it doesn't equal 3
			{ (a * b).postln };	// when i equals 3, do a * b
						// ... which is a problem if b is nil
		1.wait;

	})

});
t.start;
)
