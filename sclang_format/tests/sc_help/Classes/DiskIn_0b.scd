// Source: Classes/DiskIn.schelp block 0 (part 2/2)
(
SynthDef("help-Diskin", { |out, bufnum = 0|
	Out.ar(out, DiskIn.ar(1, bufnum));
}).add
)
