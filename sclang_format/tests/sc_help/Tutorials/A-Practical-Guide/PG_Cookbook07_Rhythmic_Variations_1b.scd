// Source: Tutorials/A-Practical-Guide/PG_Cookbook07_Rhythmic_Variations.schelp block 1 (part 2/4)
(
TempoClock.default.tempo = 104 / 60;

~kikEnvir = (
	parent: ~commonFuncs,
		// rhythm pattern that is constant in each bar
	baseAmp: #[1, 0, 0, 0,  0, 0, 0.7, 0,  0, 1, 0, 0,  0, 0, 0, 0] * 0.5,
	baseDecay: #[0.15, 0, 0, 0,  0, 0, 0.15, 0,  0, 0.15, 0, 0,  0, 0, 0, 0],
	addNotes: {
		var	beat16pos = (thisThread.clock.beats - ~startTime) % 16,
			available = ~getRestIndices.(~baseAmp);
		~amp = ~baseAmp.copy;
		~decay2 = ~baseDecay.copy;
			// if last bar of 4beat cycle, do busier fills
		if(beat16pos.inclusivelyBetween(12, 16)) {
			available.scramble[..rrand(5, 10)].do({ |index|
					// crescendo
				~amp[index] = index.linexp(0, 15, 0.2, 0.5);
				~decay2[index] = 0.15;
			});
		} {
			available.scramble[..rrand(0, 2)].do({ |index|
				~amp[index] = rrand(0.15, 0.3);
				~decay2[index] = rrand(0.05, 0.1);
			});
		}
	}
);

~snrEnvir = (
	parent: ~commonFuncs,
	baseAmp: #[0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 0] * 1.5,
	baseDecay: #[0, 0, 0, 0,  0.7, 0, 0, 0,  0, 0, 0, 0,  0.4, 0, 0, 0],
	addNotes: {
		var	beat16pos = (thisThread.clock.beats - ~startTime) % 16,
			available = ~getRestIndices.(~baseAmp),
			choice;
		~amp = ~baseAmp.copy;
		~decay = ~baseDecay.copy;
		if(beat16pos.inclusivelyBetween(12, 16)) {
			available.scramble[..rrand(5, 9)].do({ |index|
				~amp[index] = index.linexp(0, 15, 0.5, 1.8);
				~decay[index] = rrand(0.2, 0.4);
			});
		} {
			available.scramble[..rrand(1, 3)].do({ |index|
				~amp[index] = rrand(0.15, 0.3);
				~decay[index] = rrand(0.2, 0.4);
			});
		}
	}
);

~hhEnvir = (
	parent: ~commonFuncs,
	baseAmp: 15 ! 16,
	baseDelta: 0.25 ! 16,
	addNotes: {
		var	beat16pos = (thisThread.clock.beats - ~startTime) % 16,
			available = (0..15),
			toAdd;
			// if last bar of 4beat cycle, do busier fills
		~amp = ~baseAmp.copy;
		~dur = ~baseDelta.copy;
		if(beat16pos.inclusivelyBetween(12, 16)) {
			toAdd = available.scramble[..rrand(2, 5)]
		} {
			toAdd = available.scramble[..rrand(0, 1)]
		};
		toAdd.do({ |index|
			~amp[index] = ~doubleTimeAmps;
			~dur[index] = ~doubleTimeDurs;
		});
	},
	doubleTimeAmps: Pseq(#[15, 10], 1),
	doubleTimeDurs: Pn(0.125, 2)
);


~kik = Penvir(~kikEnvir, Pn(Plazy({
	~init.value;
	~addNotes.value;
	Pbindf(
		Pbind(
			\instrument, \kik,
			\preamp, 0.4,
			\dur, 0.25,
			*(~pbindPairs.value(#[amp, decay2]))
		),
			// default Event checks \freq --
			// if a symbol like \rest or even just \,
			// the event is a rest and no synth will be played
		\freq, Pif(Pkey(\amp) > 0, 1, \rest)
	)
}), inf)).play(quant: 4);

~snr = Penvir(~snrEnvir, Pn(Plazy({
	~init.value;
	~addNotes.value;
	Pbindf(
		Pbind(
			\instrument, \kraftySnr,
			\dur, 0.25,
			*(~pbindPairs.value(#[amp, decay]))
		),
		\freq, Pif(Pkey(\amp) > 0, 5000, \rest)
	)
}), inf)).play(quant: 4);

~hh = Penvir(~hhEnvir, Pn(Plazy({
	~init.value;
	~addNotes.value;
	Pbindf(
		Pbind(
			\instrument, \kraftySnr,
			\rq, 0.06,
			\amp, 15,
			\decay, 0.04,
			*(~pbindPairs.value(#[amp, dur]))
		),
		\freq, Pif(Pkey(\amp) > 0, 12000, \rest)
	)
}), inf)).play(quant: 4);
)
