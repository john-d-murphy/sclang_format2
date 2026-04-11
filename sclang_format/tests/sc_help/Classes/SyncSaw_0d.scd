// Source: Classes/SyncSaw.schelp block 0 (part 4/4)
(
scope {
	var freq = 400;
	[
	SyncSaw.ar(freq, freq * MouseX.kr(1, 3)), // modulate saw freq
	Impulse.ar(freq) // to show sync rate
] * 0.3 }
)
