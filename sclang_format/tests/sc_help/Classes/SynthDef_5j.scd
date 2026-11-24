// Source: Classes/SynthDef.schelp block 5 (part 10/17)
(
SynthDef(\trigTest2, { |out, trig = 0, freq = 440|
	Out.ar(out, SinOsc.ar(freq+[0, 1], 0, Decay2.kr(trig, 0.005, 1.0)));
	}, [0, \tr, 4]		// lag the freq (lagtime: 4s), \tr creates a TrigControl for trig
).add;
)
