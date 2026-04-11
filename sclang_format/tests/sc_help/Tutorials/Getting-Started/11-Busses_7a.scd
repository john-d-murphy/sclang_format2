// Source: Tutorials/Getting-Started/11-Busses.schelp block 7 (part 1/6)
(
SynthDef("tutorial-Infreq", { arg bus, freqOffset = 0, out;
	// this will add freqOffset to whatever is read in from the bus
	Out.ar(out, SinOsc.ar(In.kr(bus) + freqOffset, 0, 0.5));
}).add;

SynthDef("tutorial-Outfreq", { arg freq = 400, bus;
	Out.kr(bus, SinOsc.kr(1, 0, freq/40, freq));
}).add;

b = Bus.control(s,1);
)
