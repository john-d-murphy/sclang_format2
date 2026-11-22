// Source: Guides/Tracing-Processes.schelp block 7
fork {
	var str = Routine { |in| 10.do { in = in.rand.yield } };
	12.0.do { |i|
		str.next(i).postln;
		0.5.wait;
	};
}
