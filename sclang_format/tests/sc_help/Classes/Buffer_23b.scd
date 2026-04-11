// Source: Classes/Buffer.schelp block 23 (part 2/15)
(
SynthDef(\help_Buffer_copy, {
	arg out = 0, buf;
	Line.ar(0, 0, dur: BufDur.kr(buf), doneAction: Done.freeSelf);
	Out.ar(out, PlayBuf.ar(1, buf));
}).add;
)
