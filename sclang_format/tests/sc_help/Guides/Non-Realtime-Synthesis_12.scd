// Source: Guides/Non-Realtime-Synthesis.schelp block 12
(
x = Pbind(
	\freq, Pexprand(200, 800, inf),
	\dur, Pexprand(0.8, 1.25, inf) * Pgeom(0.01, 1.0143978590819, 400),
	\legato, 3,
).asScore(10, timeOffset: 0.001);

x.add([0.0, [\d_recv, SynthDescLib.global[\default].def.asBytes]]);
x.sort;

x.recordNRT(
	outputFilePath: "~/nrt.wav".standardizePath,
	sampleRate: 44100,
	headerFormat: "wav",
	sampleFormat: "int16",
	options: ServerOptions.new.numOutputBusChannels_(2),
	duration: 10
);
)
