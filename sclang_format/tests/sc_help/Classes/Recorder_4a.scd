// Source: Classes/Recorder.schelp block 4 (part 1/7)
(
SynthDef("bubbles", { |out|
	var f, sound;
	f = LFSaw.kr(0.4, 0, 24, LFSaw.kr([8, 7.23], 0, 3, 80)).midicps; // glissando function
	sound = CombN.ar(SinOsc.ar(f, 0, 0.04), 0.2, 0.2, 4); // echoing sine wave
	Out.ar(out, sound);
}).add;

SynthDef("tpulse", { |out = 0, freq = 700, sawFreq = 440.0|
	Out.ar(out, SyncSaw.ar(freq, sawFreq, 0.1))
}).add;

)
