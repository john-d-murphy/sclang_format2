// Source: Guides/Non-Realtime-Synthesis.schelp block 16
(
var nrtserver = Server(\nrt,
    options: ServerOptions.new
    .numOutputBusChannels_(2)
    .numInputBusChannels_(2)
);

//control bus allocation
var bus = Bus.control(nrtserver, 2);
var lfo, sine;

//LFO
SynthDef.new(\lfo, {|out, freq=100|
	Out.kr(out, LFNoise0.kr(freq).exprange(20.0,1000))
}).load;

lfo = Synth.basicNew(\lfo, server: nrtserver);

SynthDef.new(\NRTsine, {|out=0, freq=440|
	Out.ar(out, SinOsc.ar(freq, 0, 0.2).dup)
}).load;

sine = Synth.basicNew(\NRTsine, server: nrtserver);

a = Score([
	[0.0, lfo.newMsg(args:[\out, bus])],
	[0.0, sine.newMsg],
	[0.0, sine.mapMsg(\freq, bus)],
]);

a.recordNRT(
    outputFilePath: "~/nrtbus-help.wav".standardizePath,
    headerFormat: "wav",
    sampleFormat: "int16",
    options: nrtserver.options,
    duration: 1,
    action: { "done".postln }
);

nrtserver.remove;
)
