// Source: Classes/Bus.schelp block 3 (part 32/36)
(	// just channels[[2, 3]];
y = SynthDef(\helpBusMulti, { |out|
	Out.ar(out, LFNoise2.ar(b.kr(2, 2)) * 0.2);
}).play;
)
