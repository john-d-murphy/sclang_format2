// Source: Classes/Bus.schelp block 3 (part 29/36)
(	// just get the first 2 channels
x = SynthDef(\helpBusMulti, { |out|
	Out.ar(out, SinOsc.ar(b.kr(2)) * 0.2)
}).play;
)
