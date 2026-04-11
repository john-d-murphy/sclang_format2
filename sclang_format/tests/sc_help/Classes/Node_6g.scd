// Source: Classes/Node.schelp block 6 (part 7/10)
(
b = Bus.control(s, 2);
b.set(880, 884);
x = SynthDef("help-Node-map2", { |out, freqs = #[440, 440]|
	Out.ar(out, SinOsc.ar(freqs, 0, 0.1));
}).play
)
