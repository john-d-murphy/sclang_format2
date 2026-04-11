// Source: Classes/Pavaroh.schelp block 0 (part 2/3)
(
SynthDef("ivg", { arg out, freq=900, pan;
	var trig, snd;
	trig = Impulse.kr(LFClipNoise.kr(4, 3, LFClipNoise.kr(0.2, 2, 7)));
	snd = RLPF.ar(
		SinOsc.ar(freq, 0, Decay.kr(trig, 1.8)).distort
		, 554, 0.3)
	* 0.1;
	Out.ar(out, Pan2.ar(snd, pan))
 }).add;
)
