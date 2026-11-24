// Source: Tutorials/A-Practical-Guide/PG_Cookbook06_Phrase_Network.schelp block 1 (part 1/3)
(
// this SynthDef has a strong attack, emphasizing the articulation
SynthDef(\sawpulse, { |out, freq = 440, gate = 0.5, plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05, amp = 1|
	var sig, plfo, fcurve;
	plfo = SinOsc.kr(plfofreq, mul:mw, add:1);
	freq = Lag.kr(freq, freqlag) * plfo;
	fcurve = EnvGen.kr(Env.adsr(0, 0.3, 0.1, 20), gate);
	fcurve = (fcurve - 1).madd(0.7, 1) * ffreq;
	sig = Mix.ar([Pulse.ar(freq, 0.9), Saw.ar(freq*1.007)]);
	sig = RLPF.ar(sig, fcurve, rq)
		* EnvGen.kr(Env.adsr(0.04, 0.2, 0.6, 0.1), gate, doneAction: Done.freeSelf)
		* amp;
	Out.ar(out, sig ! 2)
}).add;
)
