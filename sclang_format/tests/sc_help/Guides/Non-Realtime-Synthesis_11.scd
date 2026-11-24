// Source: Guides/Non-Realtime-Synthesis.schelp block 11
(
var server,
inputFile = SoundFile.openRead(ExampleFiles.child);

inputFile.close;  // doesn't need to stay open; we just need the stats

server = Server(\nrt,
	options: ServerOptions.new
	.numOutputBusChannels_(2)
	.numInputBusChannels_(inputFile.numChannels)
);

x = Score([
	[0.0, ['/d_recv',
		SynthDef(\fft, {
			var in = SoundIn.ar([0]),
			fft = FFT(LocalBuf(1024, 1), in);
			fft = PV_MagFreeze(fft, ToggleFF.kr(Dust.kr(12)));
			Out.ar(0, IFFT(fft).dup)
		}).asBytes
	]],
	[0.0, Synth.basicNew(\fft, server).newMsg]
]);

x.recordNRT(
	outputFilePath: "~/nrt.wav".standardizePath,
	inputFilePath: inputFile.path,
	sampleRate: 44100,
	headerFormat: "wav",
	sampleFormat: "int16",
	options: server.options,
	duration: inputFile.duration
);

server.remove;
)
