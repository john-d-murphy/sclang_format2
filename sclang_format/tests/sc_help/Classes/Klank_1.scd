// Source: Classes/Klank.schelp block 1
(
play({
	Klank.ar(`[
		Array.rand(12, 800.0, 4000.0), 		// frequencies
		nil, 							// amplitudes (default to 1.0)
		Array.rand(12, 0.1, 2)				// ring times
		], Decay.ar(Impulse.ar(4), 0.03, ClipNoise.ar(0.01)))
})
)
