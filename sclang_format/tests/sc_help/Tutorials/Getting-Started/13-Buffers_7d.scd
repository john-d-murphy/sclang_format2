// Source: Tutorials/Getting-Started/13-Buffers.schelp block 7 (part 4/5)
(
SynthDef("tutorial-playback",{ arg out=0,bufnum=0;
	var playbuf;
	playbuf = PlayBuf.ar(1,bufnum);
	FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf has played through once
	Out.ar(out, playbuf);
}).play(s,[\out, 0, \bufnum, b]);
)
