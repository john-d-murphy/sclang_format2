// Source: Tutorials/Getting-Started/11-Busses.schelp block 4
(
SynthDef.new("tutorial-SinOsc-stereo", { |out|
	var outArray;
	outArray = [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)];
	Out.ar(out, outArray); // writes to busses 0 and 1
}).play;
)
