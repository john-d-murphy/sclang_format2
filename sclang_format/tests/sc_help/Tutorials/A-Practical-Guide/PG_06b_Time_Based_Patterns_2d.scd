// Source: Tutorials/A-Practical-Guide/PG_06b_Time_Based_Patterns.schelp block 2 (part 4/6)
r = fork {
	var stream = e.asStream;
	12.do({
		stream.next.postln;
		0.25.wait;
	});
};
