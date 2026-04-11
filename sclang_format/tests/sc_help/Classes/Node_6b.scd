// Source: Classes/Node.schelp block 6 (part 2/10)
(
b = Bus.control(s, 1); b.set(880);
c = Bus.control(s, 1);	c.set(884);
x = SynthDef("help-Node-map", { |out, freq1 = 440, freq2 = 440|
	Out.ar(out, SinOsc.ar([freq1, freq2], 0, 0.1));
}).play
)
