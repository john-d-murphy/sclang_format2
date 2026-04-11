// Source: Classes/Ramp.schelp block 2 (part 2/3)
(
// used to lag pitch
{
	SinOsc.ar(		// sine wave
		Ramp.kr(			// lag the modulator
			LFPulse.kr(4, 0, 0.5, 50, 400),	// frequency modulator
			Line.kr(0, 1, 15)				// modulate lag time
		),
		0,	// phase
		0.3	// sine amplitude
	)
}.scope;
)
