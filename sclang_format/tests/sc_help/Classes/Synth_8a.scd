// Source: Classes/Synth.schelp block 8 (part 1/20)
(
// first collect some things to play with
SynthDef("moto-rev", { arg out=0;
	var x;
	x = RLPF.ar(LFPulse.ar(SinOsc.kr(0.2, 0, 10, 21), [0,0.1], 0.1),
		100, 0.1).clip2(0.4);
	Out.ar(out, x);
}).add;

SynthDef("bubbles", { arg out=0;
	var f, zout;
	f = LFSaw.kr(0.4, 0, 24, LFSaw.kr([8,7.23], 0, 3, 80)).midicps;
	zout = CombN.ar(SinOsc.ar(f, 0, 0.04), 0.2, 0.2, 4); // echoing sine wave
	Out.ar(out, zout);
}).add;


SynthDef("rlpf",{ arg out=0,ffreq=600,rq=0.1;
	ReplaceOut.ar( out, RLPF.ar( In.ar(out), ffreq,rq) )
}).add;


SynthDef("wah", { arg out, rate = 1.5, cfreq = 1400, mfreq = 1200, rq=0.1;
	var zin, zout;

	zin = In.ar(out, 2);
	cfreq = Lag3.kr(cfreq, 0.1);
	mfreq = Lag3.kr(mfreq, 0.1);
	rq   = Ramp.kr(rq, 0.1);
	zout = RLPF.ar(zin, LFNoise1.kr(rate, mfreq, cfreq), rq, 10).distort
					* 0.15;

	// replace the incoming bus with the effected version
	ReplaceOut.ar( out , zout );

}).add;

SynthDef("modulate",{ arg out = 0, freq = 1, center = 440, plusMinus = 110;
	Out.kr(out, SinOsc.kr(freq, 0, plusMinus, center));
}).add;
)
