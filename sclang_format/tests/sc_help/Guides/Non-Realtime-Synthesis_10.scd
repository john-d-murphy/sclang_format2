// Source: Guides/Non-Realtime-Synthesis.schelp block 10
(
var server = Server(\nrt,
	options: ServerOptions.new
	.numOutputBusChannels_(2)
	.numInputBusChannels_(2)
),
defaultGroup = Group.basicNew(server);

var time = 0;

x = Score([
	[0.0, ['/d_recv',
		SynthDef(\singrain, { |out, freq = 440, time = 0.1, amp = 0.1|
			var eg = EnvGen.kr(Env.perc(0.01, time), doneAction: 2),
			sig = SinOsc.ar(freq) * amp;
			Out.ar(out, (sig * eg).dup);
		}).asBytes
	]],
	[0.0, defaultGroup.newMsg]
]);

100.do {
	x.add([time, Synth.basicNew(\singrain, server)
		.newMsg(g, [freq: exprand(200, 800), time: exprand(0.1, 1.0)])
	]);
	time = time + exprand(0.02, 0.25)
};

x.recordNRT(
	outputFilePath: "~/nrt.wav".standardizePath,
	sampleRate: 44100,
	headerFormat: "wav",
	sampleFormat: "int16",
	options: server.options,
	duration: x.endTime + 1
);

server.remove;
)
