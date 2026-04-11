// Source: Classes/Ref.schelp block 5
(
	Pbind(*[
		instrument: \multi,
		freq: 	Prand([
						[[100, 141, 103] ],
						[[100, 310, 190] ],
						[[100, 100.1, 110] ],
				], inf),
		dur: 0.2,
		sustain: 0.3
	]).play;
)
