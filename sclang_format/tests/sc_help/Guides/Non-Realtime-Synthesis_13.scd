// Source: Guides/Non-Realtime-Synthesis.schelp block 13
(
var server = Server(\nrt,
	options: ServerOptions.new
	.numOutputBusChannels_(2)
	.numInputBusChannels_(2)
),
def = SynthDef(\buf1, { |out, bufnum, rate = 1, time = 0.1, start = 0, amp = 0.1|
	var eg = EnvGen.kr(Env.perc(0.01, time), doneAction: 2),
	sig = PlayBuf.ar(1, bufnum, rate, startPos: start);
	Out.ar(out, (sig * (eg * amp)).dup);
}),
// the pattern needs a placeholder for the buffer
buf = Buffer.new(server, 0, 1);

def.add;  // the pattern needs the def in the SynthDescLib

x = Pbind(
	\instrument, \buf1,
	\bufnum, buf,
	\rate, Pexprand(0.5, 2, inf),
	\start, Pwhite(0, 50000, inf),
	\time, 0.1,
	\dur, Pexprand(0.05, 0.5, inf),
	\legato, 3,
).asScore(duration: 20, timeOffset: 0.001);

// the score also needs the def and buffer
x.add([0.0, [\d_recv, def.asBytes]]);
x.add([0.0, buf.allocReadMsg(ExampleFiles.child)]);
x.sort;

x.recordNRT(
	outputFilePath: "~/nrt.wav".standardizePath,
	sampleRate: 44100,
	headerFormat: "wav",
	sampleFormat: "int16",
	options: server.options,
	duration: 20
);

server.remove;
)
