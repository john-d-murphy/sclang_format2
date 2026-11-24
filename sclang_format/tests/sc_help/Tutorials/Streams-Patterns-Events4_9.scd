// Source: Tutorials/Streams-Patterns-Events4.schelp block 9
(
var f;

// define a function
f = { arg x, y, z; [x, y, z].postln; };

Environment.use({
	~x = 7;
	~y = 8;
	~z = 9;

	f.valueEnvir(1, 2, 3);	// all values supplied
	f.valueEnvir(1, 2);	// z is looked up in the current Environment
	f.valueEnvir(1);	// y and z are looked up in the current Environment
	f.valueEnvir;		// all arguments are looked up in the current Environment
	f.valueEnvir(z: 1);	// x and y are looked up in the current Environment
});
)
