// Source: Tutorials/Server_Tutorial.schelp block 13 (part 2/2)
(
SynthDef("sine", { arg freq;
	var osc;
	osc = SinOsc.ar(freq, 0, 0.1); // 800 Hz sine oscillator
	Out.ar(0, osc); // send output to audio bus zero.
}).add;
)
