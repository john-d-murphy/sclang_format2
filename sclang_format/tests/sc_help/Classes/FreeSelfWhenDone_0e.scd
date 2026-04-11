// Source: Classes/FreeSelfWhenDone.schelp block 0 (part 5/6)
(
SynthDef("help-RecordBuf",{ arg out=0,bufnum=0;
	var formant, recbuf;
	formant = Formant.ar(XLine.kr(400,1000, 4), 2000, 800, 0.125);
	recbuf = RecordBuf.ar(formant, bufnum, recLevel: Line.kr(1, 1), loop: 0);
	// The RecordBuf doesn't loop, so you can check it for 'done' status
	FreeSelfWhenDone.kr(recbuf);
}).play(s,[\out, 0, \bufnum, b]);
)
