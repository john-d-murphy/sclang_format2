// Source: Classes/DiskIn.schelp block 1 (part 13/14)
(
SynthDef("help-Diskin", { |out, bufnum = 0|
	Out.ar(out, DiskIn.ar(1, bufnum));
}).add;
)
