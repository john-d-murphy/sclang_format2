// Source: Classes/Amplitude.schelp block 0 (part 1/2)
(
{
	// LFSaw begins at 0, illustrates attack time better
	var sig = LFSaw.ar(440);
	var amps = Amplitude.ar(
		sig,
		attackTime: [0.001, 0.01],
		releaseTime: [0.01, 0.2]
	);
	[sig] ++ amps
}.plot
.superpose_(true)
.plotColor_([Color.black, Color.green, Color.blue]);
)
