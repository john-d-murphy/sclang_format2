// Source: Tutorials/Getting-Started/13-Buffers.schelp block 7 (part 2/5)
(
x = SynthDef("tutorial-RecordBuf",{ arg out=0,bufnum=0;
	var noise;
	noise = PinkNoise.ar(0.3);	// record some PinkNoise
	RecordBuf.ar(noise, bufnum); 	// by default this loops
}).play(s,[\out, 0, \bufnum, b]);
)
