// Source: Classes/CoinGate.schelp block 0 (part 5/8)
(
a = SynthDef("help-TCoin", { arg out=0, prob=0.5;
	var trig;
	trig = Impulse.ar(20, 0, SinOsc.kr(0.5,0,1,1));
	Out.ar(out,
		Mix.fill(3, {Ringz.ar(CoinGate.ar(prob, trig*0.5), #[1,1.5]*Rand(1000, 9000), 0.01)})
	)
}).play;
)
