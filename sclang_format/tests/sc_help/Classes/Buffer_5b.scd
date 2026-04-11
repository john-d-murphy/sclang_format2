// Source: Classes/Buffer.schelp block 5 (part 2/5)
(
SynthDef(\help_Buffer_cue,{ arg out=0,bufnum;
	Out.ar(out,
		DiskIn.ar( 1, bufnum )
	)
}).add;
)
