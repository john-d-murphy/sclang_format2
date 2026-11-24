// Source: Guides/Tracing-Processes.schelp block 6
fork {
	var n = 14;
	(1..n).do { |num|
		{ num.rand }.dup(200).postcs;
		1.wait;
	};
}
