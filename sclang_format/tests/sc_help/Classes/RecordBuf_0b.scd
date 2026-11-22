// Source: Classes/RecordBuf.schelp block 0 (part 2/8)
(
SynthDef(\help_RecordBuf, { |out = 0, bufnum = 0|
	var formant;
	formant = Formant.ar(XLine.kr(400, 1000, 4), 2000, 800, 0.125);
	RecordBuf.ar(formant, bufnum, doneAction: Done.freeSelf, loop: 0);
}).play(s, [\out, 0, \bufnum, b]);
)
