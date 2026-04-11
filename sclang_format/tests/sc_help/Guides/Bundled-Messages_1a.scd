// Source: Guides/Bundled-Messages.schelp block 1 (part 1/3)
(
s.bind {
	SynthDef("tpulse2", { arg out=0, freq=700, sawFreq=440.0;
		Out.ar(out, Pan2.ar(SyncSaw.ar(freq,  sawFreq, 0.1), SinOsc.kr(8)) )
	}).send(s);
	s.sync; // wait until synthdef is loaded
	x = Synth.new("tpulse2");
	a = Bus.control.set(440);
	x.map(\freq, a);
};
)
