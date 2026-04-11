// Source: Classes/CoinGate.schelp block 0 (part 1/8)
(
a = SynthDef("help-TCoin", { arg out=0, prob=0.5;
	var trig;
	trig = CoinGate.kr(prob, Impulse.kr(10));
	Out.ar(out,
		SinOsc.ar(
			TRand.kr(300.0, 400.0, trig),0,0.2
		)
	)
}).play;
)
