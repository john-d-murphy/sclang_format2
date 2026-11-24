// Source: Classes/Routine.schelp block 4 (part 1/2)
(
r = Routine { |inval|
	inval.postln; // Post the value passed in when started.
	5.do { |i|
		inval = (i + 10).yield;
		inval.postln; // Post the value passed in when resumed.
	}
}
)
