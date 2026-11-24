// Source: Classes/Event.schelp block 13 (part 1/3)
(
SynthDef(\pm, { |out = 0, freq = 440, amp = 0.1, pan = 0, gate = 1, ratio = 1, index = 1, ar = 0.1, dr = 0.1|
	var z;
	z = LPF.ar(
		PMOsc.ar(freq, freq * ratio, Linen.kr(gate, ar, index, dr), 0, 0.3),
		XLine.kr(Rand(4000, 5000), Rand(2500, 3200), 1)
	) * Linen.kr(gate, 0.01, 0.7, dr, 2);
	OffsetOut.ar(out, Pan2.ar(z, pan, amp));
}).add;
);
