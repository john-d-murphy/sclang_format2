// Source: Guides/Multichannel-Expansion.schelp block 14 (part 1/2)
(
SynthDef(\blip, { |out, freq|
	Out.ar(out,
		Line.ar(0.1, 0, 0.05, 1, 0, 2) * Pulse.ar(freq * [1, 1.02])
	)
}).add;

a = { |dur=1, x=1, n=10, freq=400|
	fork {
		n.do {
			if(x.coin) { Synth(\blip, [\freq, freq]) };
			(dur / n).wait;
		}
	}
}.flop;
)
