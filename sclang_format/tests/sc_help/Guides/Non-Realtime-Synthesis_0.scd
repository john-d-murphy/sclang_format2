// Source: Guides/Non-Realtime-Synthesis.schelp block 0
(
var server = Server(\nrt,
	options: ServerOptions.new
	.numOutputBusChannels_(2)
	.numInputBusChannels_(2)
);

a = Score([
	[0.0, ['/d_recv',
		SynthDef(\NRTsine, { |out, freq = 440|
			Out.ar(out, SinOsc.ar(freq, 0, 0.2).dup)
		}).asBytes
	]],
	[0.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 400])],
	[1.0, x.freeMsg]
]);

a.recordNRT(
	outputFilePath: "~/nrt-help.wav".standardizePath,
	headerFormat: "wav",
	sampleFormat: "int16",
	options: server.options,
	duration: 1,
	action: { "done".postln }
);

server.remove;
)
