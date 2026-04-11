// Source: Classes/Buffer.schelp block 5 (part 3/5)
(
s.makeBundle(nil, {
	b = Buffer.cueSoundFile(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav", 0, 1);
	y = Synth(\help_Buffer_cue, [\bufnum, b], s);
});
)
