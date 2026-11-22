// Source: Tutorials/Server_Tutorial.schelp block 20 (part 1/8)
(
// define a noise pulse
SynthDef("tish", { arg freq = 1200, rate = 2;
	var osc, trg;
	trg = Decay2.ar(Impulse.ar(rate,0,0.3), 0.01, 0.3);
	osc = {WhiteNoise.ar(trg)}.dup;
	Out.ar(0, osc); // send output to audio bus zero.
}).add;
)
