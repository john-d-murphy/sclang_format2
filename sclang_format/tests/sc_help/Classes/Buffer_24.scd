// Source: Classes/Buffer.schelp block 24
(
s.waitForBoot {
	var w = Window("parent");
	var buf = Buffer.read(s, ExampleFiles.sinedPink);
	s.sync;
	buf.plot(parent: w);
	w.front
}
)
