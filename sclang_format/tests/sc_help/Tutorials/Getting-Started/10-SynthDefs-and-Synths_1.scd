// Source: Tutorials/Getting-Started/10-SynthDefs-and-Synths.schelp block 1
(
SynthDef.new("tutorial-SinOsc-stereo", { |out|
	var outArray;
	outArray = [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)];
	Out.ar(out, outArray)
}).play;
)
