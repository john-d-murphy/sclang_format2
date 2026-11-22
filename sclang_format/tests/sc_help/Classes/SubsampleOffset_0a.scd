// Source: Classes/SubsampleOffset.schelp block 0 (part 1/5)
(
SynthDef(\Help_SubsampleOffset, { |out, addOffset|
	var in, dt, sampDur, extraSamples, sampleOffset, resampledSignal;
	in = Impulse.ar(2000, 0, 0.3); // some input.
	sampDur = SampleDur.ir; 	// duration of one sample
	extraSamples = 4;			// DelayC needs at least 4 samples buffer
	sampleOffset = 1 - SubsampleOffset.ir; // balance out subsample offset
	sampleOffset = sampleOffset + MouseX.kr(0, addOffset); // add a mouse dependent offset
	// cubic resampling:
	resampledSignal = DelayC.ar(in,
							maxdelaytime: sampDur * (1 + extraSamples),
							delaytime: sampDur * (sampleOffset + extraSamples)
					);
	OffsetOut.ar(out, resampledSignal)
}).add;
)
