// Source: Classes/Bus.schelp block 1 (part 2/2)
(
SynthDef(\rlpf, { |out, ffreq, rq|
	Out.ar(out, RLPF.ar(WhiteNoise.ar(0.2), ffreq, rq))
}).play(s, [\ffreq, a.asMap, \rq, b.asMap]);
)
