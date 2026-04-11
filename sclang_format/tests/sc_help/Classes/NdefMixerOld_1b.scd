// Source: Classes/NdefMixerOld.schelp block 1 (part 2/7)
(
Ndef(\a, {
	Pan2.ar(
		Ringz.ar(
			Impulse.ar(exprand(0.5, 4)),
			exprand(300, 3000),
			0.02
		),
	1.0.rand2,
	0.2)
})
);
