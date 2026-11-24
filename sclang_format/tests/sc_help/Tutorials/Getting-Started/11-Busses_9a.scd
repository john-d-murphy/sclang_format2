// Source: Tutorials/Getting-Started/11-Busses.schelp block 9 (part 1/10)
(
// make two control rate busses and set their values to 880 and 884.
b = Bus.control(s, 1); b.set(880);
c = Bus.control(s, 1); c.set(884);
// and make a synth with two frequency arguments
x = SynthDef("tutorial-map", { arg freq1 = 440, freq2 = 440, out;
	Out.ar(out, SinOsc.ar([freq1, freq2], 0, 0.1));
}).play(s);
)
