// Source: Tutorials/Server_Tutorial.schelp block 21
(
// define a control
SynthDef("line", { arg i_bus=10, i_start=1000, i_end=500, i_time=1;
	ReplaceOut.kr(i_bus, Line.kr(i_start, i_end, i_time, doneAction: Done.freeSelf));
}).add
)
