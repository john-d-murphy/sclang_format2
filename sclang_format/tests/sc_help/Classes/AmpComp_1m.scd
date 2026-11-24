// Source: Classes/AmpComp.schelp block 1 (part 13/15)
(
fork {
	loop {
		s.sendBundle(0.1, [\s_new, \pgrain, -1, 1, 1]);
		0.02.wait;
	};
}
)
