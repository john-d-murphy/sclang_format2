// Source: Classes/Server.schelp block 15 (part 11/13)
(
s.makeBundle(nil, {
	b = Buffer.read(s, ExampleFiles.child);
	s.sync; // wait until load is done and then send the rest of the bundle
	x = { PlayBuf.ar(1, b) * 0.5 }.play;
});
)
