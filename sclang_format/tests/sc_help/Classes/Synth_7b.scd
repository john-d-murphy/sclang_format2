// Source: Classes/Synth.schelp block 7 (part 2/16)
(
// send a synth def to server
SynthDef("tpulse", { arg out = 0,freq = 700, sawFreq = 440.0;
	Out.ar(out, SyncSaw.ar(freq, sawFreq, 0.1));
}).add;
)
