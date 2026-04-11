// Source: Classes/Scale.schelp block 7 (part 1/2)
(
r = {
	var scale = Scale.choose.postln;
	SinOsc.ar(
		(
			DegreeToKey.kr(
				scale.as(LocalBuf),
				MouseX.kr(0,15), // mouse indexes into scale
				scale.stepsPerOctave,
				1, // mul = 1
				60 // offset by 72 notes
			)
			+ LFNoise1.kr([3,3], 0.04) // add some low freq stereo detuning
		).midicps, // convert midi notes to hertz
		0,
		0.25
	)
}.play;
)
