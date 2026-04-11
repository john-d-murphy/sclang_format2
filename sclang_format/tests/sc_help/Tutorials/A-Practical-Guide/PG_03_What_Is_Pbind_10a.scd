// Source: Tutorials/A-Practical-Guide/PG_03_What_Is_Pbind.schelp block 10 (part 1/3)
(
SynthDef(\trig_demo, { |out, freq = 440, gate = 1, t_trig = 1|	// t_trig here
	var	env = Decay2.kr(t_trig, 0.01, 0.1),
		sig = SinOsc.ar(freq, 0, env)
			* Linen.kr(gate, 0.01, 0.1, 0.1, doneAction: Done.freeSelf);
	Out.ar(out, sig ! 2)
}).add;
)
