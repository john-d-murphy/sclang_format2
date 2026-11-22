// Source: Classes/FreeSelf.schelp block 0 (part 5/5)
(
Task {
	loop({
		fork {
			exprand(34, 156).do { |i|
				i = i + 1;
				s.sendMsg("/s_new", "dirac", -1, 0, 0, \amp, 1 / i);
				(0.006 * i).wait;
			};
		};
		1.wait;
	})
} .play;
)
