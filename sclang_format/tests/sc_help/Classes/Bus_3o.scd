// Source: Classes/Bus.schelp block 3 (part 15/36)
(
b = Bus.control(s, 4);

x = SynthDef(\helpBusMulti, { |out|
	var freqs = b.kr;
	Out.ar(out, Splay.ar(SinOsc.ar(freqs) * Decay2.ar(Dust.ar(10 ! 4), 0.001, 0.1)) * 0.5);
}).play;
)
