// Source: Classes/Buffer.schelp block 5 (part 3/5)
(
s.makeBundle(nil, {
	b = Buffer.cueSoundFile(s, ExampleFiles.child, 0, 1);
	y = Synth(\help_Buffer_cue, [\bufnum, b], s);
});
)
