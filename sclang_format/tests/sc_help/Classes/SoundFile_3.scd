// Source: Classes/SoundFile.schelp block 3
SynthDef(\diskIn2, { |out, amp=1, bufnum, sustainTime, atk=0, rel=0, gate=1|
	var sig = VDiskIn.ar(2, bufnum, BufRateScale.kr(bufnum));
	var gateEnv = EnvGen.kr(Env([1, 1, 0], [sustainTime-rel, 0]));
	var env = EnvGen.kr(Env.asr(atk, 1, rel), gate * gateEnv, doneAction: Done.freeSelf);
	Out.ar(out, sig * env * amp)
});
