// Source: Classes/SyncSaw.schelp block 0 (part 3/4)
(
plot { [
	SyncSaw.ar(800, Line.kr(800, 1600, 0.01)), // modulate saw freq
	Impulse.ar(800) // to show sync rate
] }
)
