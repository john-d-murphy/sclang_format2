// Source: Classes/Group.schelp block 2 (part 2/19)
(
SynthDef("help-Group-moto-rev", { |out = 0, freq = 100, ffreq = 120|
	var x;
	x = RLPF.ar(LFPulse.ar(SinOsc.kr(0.2, 0, 10, freq), [0, 0.1], 0.1),
		ffreq, 0.1).clip2(0.4);
	Out.ar(out, x);
}).add;


SynthDef("help-Group-wah", { |out, rate = 1.5, cfreq = 1400, mfreq = 1200, rq = 0.1|
	var zin, zout, q;

	zin = In.ar(out, 2);
	cfreq = Lag3.kr(cfreq, 0.1);
	mfreq = Lag3.kr(mfreq, 0.1);
	q   = Ramp.kr(rq, 0.1);
	zout = RLPF.ar(zin, LFNoise1.kr(rate, mfreq, cfreq), q, 10).distort
		* 0.15;

	// replace the incoming bus with the effected version
	ReplaceOut.ar(out, zout);

}).add;
)
