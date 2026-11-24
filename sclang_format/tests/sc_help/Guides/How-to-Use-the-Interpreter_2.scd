// Source: Guides/How-to-Use-the-Interpreter.schelp block 2
(
// ^^^^^^^^ double click above this line ^^^^^^^^
play({
// Three patches in one...
n = 5;	// number of strings
b = [	// array of possible impulse excitation behaviours
		{ Impulse.ar(2 + 0.2.rand, 0.3) }, // slow phasing
		{ Dust.ar(0.5, 0.3) },	// "wind chimes"
		{ Impulse.ar(SinOsc.kr(0.05+0.1.rand, 2pi.rand, 5, 5.2), 0.3) } // races
	].choose;	// choose one at random to use for all voices
Mix.new(
	Array.fill(n, {	// n strings tuned randomly to MIDI keys 60-90
		var delayTime;
		// calculate delay based on a random note
		delayTime = 1 / (60 + 30.rand).midicps;
		Pan2.ar(
			LeakDC.ar(	// removes DC buildup
				CombL.ar(	// used as a string resonator
					Decay.ar(	// decaying envelope for noise
						b.value,// instantiate an exciter
						0.04,	// decay time of excitation
						PinkNoise.ar(0.2)),// multiply noise by envelope
					delayTime, 	// max delay time
					delayTime,	// actual delay time
					4)), 		// decay time of string
			1.0.rand2 // random pan position
		)
	}))
})
)
