// Source: Classes/Server.schelp block 18 (part 2/8)
(
SynthDef("bubbles", { |out|
	var f, sound;
	f = LFSaw.kr(0.4, 0, 24, LFSaw.kr([8,7.23], 0, 3, 80)).midicps; // glissando function
	sound = CombN.ar(SinOsc.ar(f, 0, 0.04), 0.2, 0.2, 4); // echoing sine wave
	Out.ar(out, sound);
}).add;
)
