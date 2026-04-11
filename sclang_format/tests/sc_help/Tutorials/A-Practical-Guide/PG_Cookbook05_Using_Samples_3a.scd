// Source: Tutorials/A-Practical-Guide/PG_Cookbook05_Using_Samples.schelp block 3 (part 1/4)
(
var recorder;
fork {
	b = Buffer.alloc(s, 44100 * 2, 1);
	s.sync;
	recorder = { |freq = 440|
		var initPulse = Impulse.kr(0),
		mod = SinOsc.ar(freq) * Decay2.kr(initPulse, 0.01, 3) * 5,
		car = SinOsc.ar(freq + (mod*freq)) * Decay2.kr(initPulse, 0.01, 2.0);
		RecordBuf.ar(car, b, loop: 0, doneAction: Done.freeSelf);
		car ! 2
	}.play;
	o = OSCFunc({ |msg|
		if(msg[1] == recorder.nodeID, {
			"done recording".postln;
			o.free;
		});
	}, '/n_end', s.addr);
};
SynthDef(\sampler, { |out, bufnum, freq = 1, amp = 1|
	var sig = PlayBuf.ar(1, bufnum, rate: freq, doneAction: Done.freeSelf) * amp;
	Out.ar(out, sig ! 2)
}).add;
)
