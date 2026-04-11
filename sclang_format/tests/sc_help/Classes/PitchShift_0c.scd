// Source: Classes/PitchShift.schelp block 0 (part 3/3)
(
// use PitchShift to granulate input - USE HEADPHONES to prevent feedback.
// upper left corner is normal playback. x = pitch dispersion, y = time dispersion
var grainSize;
grainSize = 0.5;
play({
	PitchShift.ar(
		SoundIn.ar([0, 1]),
		grainSize,
		1,						// nominal pitch rate = 1
		MouseX.kr(0,1), 			// pitch dispersion
		MouseY.kr(0, grainSize)	// time dispersion
	)
}))
