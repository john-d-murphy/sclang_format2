// Source: Classes/VDiskIn.schelp block 0 (part 8/20)
(
SynthDef("help-VDiskin", { |out, bufnum = 0|
	Out.ar(out, VDiskIn.ar(1, bufnum, MouseX.kr(0.5, 2.0)));
}).add;
)
