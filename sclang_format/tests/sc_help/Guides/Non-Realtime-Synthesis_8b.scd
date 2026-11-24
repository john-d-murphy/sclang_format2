// Source: Guides/Non-Realtime-Synthesis.schelp block 8 (part 2/2)
(
var server = Server(\nrt,
	options: ServerOptions.new
	.numOutputBusChannels_(2)
	.numInputBusChannels_(2)
);

a = Score([
	[0.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 400])],
	[1.0, x.freeMsg]
]);

a.recordNRT(
	outputFilePath: PathName.tmp +/+ "nrt-help-fail.wav",
	headerFormat: "wav",
	sampleFormat: "int16",
	options: server.options,
	duration: 1,
	action: { "done".postln }
);

server.remove;
)
