// Source: Tutorials/Streams-Patterns-Events7.schelp block 0
(
SynthDef(\help_SPE7_BerlinB, { arg i_out=0, freq = 80, amp = 0.2, pan=0;
	var out, a, b;
	amp = Decay2.kr(Impulse.kr(0), 0.05, 8, amp);
	out = RLPF.ar(
		LFPulse.ar(freq, 0, SinOsc.kr(0.12,[0,0.5pi],0.48,0.5), amp),
		freq * SinOsc.kr(0.21,0,4,8),
		0.07
	);
	#a, b = out;
	DetectSilence.ar(a, 0.0001, doneAction: Done.freeSelf);
	Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+1])));
}).add;

SynthDef(\help_SPE7_CFString1, { arg i_out, freq = 360, gate = 1, pan, amp=0.1;
	var out, eg, fc, osc, a, b, w;
	fc = LinExp.kr(LFNoise1.kr(Rand(0.25,0.4)), -1,1,500,2000);
	osc = Mix.fill(8, { LFSaw.ar(freq * [Rand(0.99,1.01),Rand(0.99,1.01)], 0, amp) }).distort * 0.2;
	eg = EnvGen.kr(Env.asr(1,1,1), gate, doneAction: Done.freeSelf);
	out = eg * RLPF.ar(osc, fc, 0.1);
	#a, b = out;
	Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+0.3])));
}).add;
)
