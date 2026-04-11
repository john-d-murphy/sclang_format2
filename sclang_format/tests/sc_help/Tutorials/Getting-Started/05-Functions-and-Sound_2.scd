// Source: Tutorials/Getting-Started/05-Functions-and-Sound.schelp block 2
(
{ 			// Open the Function
	SinOsc.ar(	// Make an audio rate SinOsc
		440, 	// frequency of 440 Hz, or the tuning A
		0, 	// initial phase of 0, or the beginning of the cycle
		0.2) 	// mul of 0.2
}.play;			// close the Function and call 'play' on it
)
