// Source: Tutorials/A-Practical-Guide/PG_06f_Server_Control.schelp block 2 (part 1/5)
(
SynthDef(\playbuf, { |bufnum, start, dur = 1, amp = 0.2, out|
	var	sig = PlayBuf.ar(1, bufnum, BufRateScale.ir(bufnum), 0, start);
	sig = sig * amp * EnvGen.kr(Env.linen(0.01, dur, 0.01), doneAction: Done.freeSelf);
	Out.ar(out, sig ! 2)
}).add;
)
