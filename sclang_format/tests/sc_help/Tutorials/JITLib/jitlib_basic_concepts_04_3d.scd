// Source: Tutorials/JITLib/jitlib_basic_concepts_04.schelp block 3 (part 4/8)
(
r = Routine {
	loop {
		200.do { arg i;
			~x.spawn;
			(0.005).wait;
		};
		1.wait;
	}
}.play;
)
