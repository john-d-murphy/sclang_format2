// Source: Tutorials/Streams-Patterns-Events7.schelp block 3
(
SynthDef(\help_SPE4_CFString2, { arg i_out, freq = 360, gate = 1, pan, amp=0.1, dorkarg=1;
	var out, eg, fc, osc, a, b, w;
	fc = LinExp.kr(LFNoise1.kr(Rand(0.25,0.4)), -1,1,500,2000);
	osc = Mix.fill(8, { LFSaw.ar(freq * [Rand(0.99,1.01),Rand(0.99,1.01)], 0, amp * dorkarg ) }).distort * 0.2;
	eg = EnvGen.kr(Env.asr(1,1,1), gate, doneAction: Done.freeSelf);
	out = eg * RLPF.ar(osc, fc, 0.1);
	#a, b = out;
	Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+0.3])));
}).send(s);	// change .send(s) to .add
)
