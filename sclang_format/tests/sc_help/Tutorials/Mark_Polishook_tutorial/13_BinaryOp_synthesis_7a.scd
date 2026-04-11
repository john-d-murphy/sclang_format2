// Source: Tutorials/Mark_Polishook_tutorial/13_BinaryOp_synthesis.schelp block 7 (part 1/2)
(
r = Routine({
	loop({
		Synth("timeScale", [\ts, 0.01.rrand(0.3)]);
		0.5.wait;
	})
});
)
