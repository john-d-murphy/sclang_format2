// Source: Classes/ControlName.schelp block 1 (part 1/2)
(
d = SynthDef(\tone, { |out = 0, freq = 200|
	var sig;

	freq.spec = ControlSpec(20, 20000);
	sig = SinOsc.ar(freq);

	Out.ar(out, sig);
}).add;
)
