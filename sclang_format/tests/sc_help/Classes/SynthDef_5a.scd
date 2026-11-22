// Source: Classes/SynthDef.schelp block 5 (part 1/17)
(
SynthDef(\trigTest1, { |out, t_trig = 0, freq = 440| // t_trig creates a TrigControl
	Out.ar(out, SinOsc.ar(freq+[0, 1], 0, Decay2.kr(t_trig, 0.005, 1.0)));
}, [0, 0, 4]		// lag the freq by 4 seconds (the second arg), but not t_trig (won't work anyway)
).add;
)
