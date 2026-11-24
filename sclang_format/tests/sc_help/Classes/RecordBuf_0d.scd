// Source: Classes/RecordBuf.schelp block 0 (part 4/8)
(
SynthDef(\help_RecordBuf_overdub, { |out = 0, bufnum = 0|
	var formant;
	formant = Formant.ar(XLine.kr(200, 1000, 4), 2000, 800, 0.125);
	// mixes equally with existing data
	RecordBuf.ar(formant, bufnum, 0, 0.3, 0.5, doneAction: Done.freeSelf, loop: 0);
}).play(s, [\out, 0, \bufnum, b]);
)
