// Source: Classes/FreeSelfWhenDone.schelp block 0 (part 6/6)
(
SynthDef("help-RecordBuf play",{ arg out=0,bufnum=0;
	var playbuf;
	playbuf = PlayBuf.ar(1,bufnum);
	FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
	Out.ar(out, playbuf);
}).play(s,[\out, 0, \bufnum, b]);
)
