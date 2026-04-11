// Source: Tutorials/Getting-Started/13-Buffers.schelp block 4 (part 1/5)
(
SynthDef("tutorial-Buffer-cue",{ arg out=0,bufnum;
	Out.ar(out,
		DiskIn.ar( 1, bufnum )
	)
}).add;
)
