// Source: Classes/LocalBuf.schelp block 2 (part 6/11)
(
play({
	var mix;

	mix =

	// lead tone
	SinOsc.ar(
		(
			DegreeToKey.kr(
				[0, 2, 3.2, 5, 7, 9, 10].as(LocalBuf),
				MouseX.kr(0, 15),		// mouse indexes into scale
				12,					// 12 notes per octave
				1,					// mul = 1
				72					// offset by 72 notes
			).poll
			+ LFNoise1.kr([3,3], 0.04)	// add some low freq stereo detuning
		).midicps,						// convert midi notes to hertz
		0,
		0.1)

	// drone 5ths
	+ RLPF.ar(LFPulse.ar([48,55].midicps, 0.15),
		SinOsc.kr(0.1, 0, 10, 72).midicps, 0.1, 0.1);

	// add some 70's euro-space-rock echo
	CombN.ar(mix, 0.31, 0.31, 2, 1, mix)
})
)
