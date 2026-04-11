// Source: Classes/Plotter.schelp block 17 (part 15/15)
(
s.waitForBoot({
	var b = Buffer.read(s,
		Platform.resourceDir +/+ "sounds/SinedPink.aiff"
	);
	s.sync;
	b.plot;
	b.free;
});
)
