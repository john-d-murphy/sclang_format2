// Source: Classes/DiskIn.schelp block 1 (part 12/13)
(
SynthDef("help-Diskin", { |out, bufnum = 0|
	Out.ar(out, DiskIn.ar(1, bufnum));
}).add;
)
