// Source: Classes/DiskOut.schelp block 0 (part 2/2)
(
// something to record
SynthDef("bubbles", { |out|
	var f, zout;
	f = LFSaw.kr(0.4, 0, 24, LFSaw.kr([8,7.23], 0, 3, 80)).midicps; // glissando function
	zout = CombN.ar(SinOsc.ar(f, 0, 0.04), 0.2, 0.2, 4); // echoing sine wave
	Out.ar(out, zout)
}).add;

// this will record to the disk
SynthDef("help-Diskout", { |bufnum|
	DiskOut.ar(bufnum, In.ar(0,2));
}).add;

// this will play it back
SynthDef("help-Diskin-2chan", { |out, bufnum = 0|
	Out.ar(out, DiskIn.ar(2, bufnum))
}).add;
)
