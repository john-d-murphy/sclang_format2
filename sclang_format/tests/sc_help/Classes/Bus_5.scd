// Source: Classes/Bus.schelp block 5
(
b = Bus(\audio, 0, 2);
s.bind {
	SynthDef(\sinPerc, { |out = 0|
		var signal = SinOsc.ar * Env.sine(0.1).ar(gate: Impulse.ar(2));
		OffsetOut.ar(out, signal ! 2) }
	).add;
	s.sync;
	Synth(\sinPerc, [\out, b]);
	b.plot(1);
}
)
