// Source: Tutorials/A-Practical-Guide/PG_Cookbook07_Rhythmic_Variations.schelp block 1 (part 1/4)
(
// this kick drum doesn't sound so good on cheap speakers
// but if your monitors have decent bass, it's electro-licious
SynthDef(\kik, { |basefreq = 50, ratio = 7, sweeptime = 0.05, preamp = 1, amp = 1,
		decay1 = 0.3, decay1L = 0.8, decay2 = 0.15, out|
	var	fcurve = EnvGen.kr(Env([basefreq * ratio, basefreq], [sweeptime], \exp)),
		env = EnvGen.kr(Env([1, decay1L, 0], [decay1, decay2], -4), doneAction: Done.freeSelf),
		sig = SinOsc.ar(fcurve, 0.5pi, preamp).distort * env * amp;
	Out.ar(out, sig ! 2)
}).add;

SynthDef(\kraftySnr, { |amp = 1, freq = 2000, rq = 3, decay = 0.3, pan, out|
	var	sig = PinkNoise.ar(amp),
		env = EnvGen.kr(Env.perc(0.01, decay), doneAction: Done.freeSelf);
	sig = BPF.ar(sig, freq, rq, env);
	Out.ar(out, Pan2.ar(sig, pan))
}).add;

~commonFuncs = (
		// save starting time, to recognize the last bar of a 4-bar cycle
	init: {
		if(~startTime.isNil) { ~startTime = thisThread.clock.beats };
	},
		// convert the rhythm arrays into patterns
	pbindPairs: { |keys|
		var	pairs = Array(keys.size * 2);
		keys.do({ |key|
			if(key.envirGet.notNil) { pairs.add(key).add(Pseq(key.envirGet, 1)) };
		});
		pairs
	},
		// identify rests in the rhythm array
		// (to know where to stick notes in)
	getRestIndices: { |array|
		var	result = Array(array.size);
		array.do({ |item, i|
			if(item == 0) { result.add(i) }
		});
		result
	}
);
)
