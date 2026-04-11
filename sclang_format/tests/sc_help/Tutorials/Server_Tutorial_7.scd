// Source: Tutorials/Server_Tutorial.schelp block 7
(
SynthDef("sine", { arg freq=800;
	var osc;
	osc = SinOsc.ar(freq, 0, 0.1); // 800 Hz sine oscillator
	Out.ar(0, osc); // send output to audio bus zero.
}).writeDefFile; // write the def to disk in the default directory synthdefs/
)
