// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/09.schelp block 9 (part 1/2)
(
r = Routine({
	loop({
		Synth("timeScale", [\ts, 0.01.rrand(0.3)]);
		0.5.wait;
	})
});
)
