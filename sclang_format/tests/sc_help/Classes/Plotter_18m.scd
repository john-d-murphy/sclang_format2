// Source: Classes/Plotter.schelp block 18 (part 13/13)
(
s.waitForBoot({
	var b = Buffer.read(s,
		ExampleFiles.sinedPink
	);
	s.sync;
	b.plot;
	b.free;
});
)
