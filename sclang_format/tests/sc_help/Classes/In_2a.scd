// Source: Classes/In.schelp block 2 (part 1/10)
(
SynthDef("help-Infreq", { arg bus;
	Out.ar(0, FSinOsc.ar(In.kr(bus), 0, 0.5));
}).add;

SynthDef("help-Outfreq", { arg freq = 400, bus;
	Out.kr(bus, SinOsc.kr(1, 0, freq/40, freq));
}).add;

b = Bus.control(s,1);
)
