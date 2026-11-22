// Source: Classes/RecordBuf.schelp block 0 (part 3/8)
(
SynthDef(\help_RecordBuf_playback, { |out = 0, bufnum = 0|
	var playbuf;
	playbuf = PlayBuf.ar(1, bufnum);
	FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
	Out.ar(out, playbuf);
}).play(s, [\out, 0, \bufnum, b]);
)
