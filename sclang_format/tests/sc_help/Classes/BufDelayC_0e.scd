// Source: Classes/BufDelayC.schelp block 0 (part 5/7)
a = { |bufs = #[0, 1]|
	var sig = SinOsc.ar([440, 880]) * Decay2.kr(Impulse.kr([2, 4]), 0.01, 0.15);
	sig + BufDelayC.ar(bufs, sig, delaytime: 0.125)
}.play(args: [bufs: b]);
