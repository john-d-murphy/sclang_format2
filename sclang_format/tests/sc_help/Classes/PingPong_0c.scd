// Source: Classes/PingPong.schelp block 0 (part 3/4)
(
s = Server.local;
s.waitForBoot({

b = Buffer.alloc(s, 44100 * 2, 2);

SynthDef("help-PingPong", { |out = 0, bufnum = 0|
	var left, right;
	left = Decay2.ar(Impulse.ar(0.7, 0.25), 0.01, 0.25,
		SinOsc.ar(SinOsc.kr(3.7,0,200,500)));
	right = Decay2.ar(Impulse.ar(0.5, 0.25), 0.01, 0.25,
		Resonz.ar(PinkNoise.ar(4), SinOsc.kr(2.7,0,1000,2500),
0.2));

	Out.ar(out,
		PingPong.ar(bufnum, [left, right] *  EnvGen.kr(Env([1, 1, 0], [2, 0.1])),
			0.1, 0.8, 1)
	)
}).play(s, [\out, 0, \bufnum, b.bufnum]);
});
)
