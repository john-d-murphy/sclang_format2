// Source: Classes/Control.schelp block 1 (part 10/17)
(
SynthDef(\help_Control_DynKlank, { arg out=0, freq = 440;
	var klank, harm, amp, ring;

	// harmonics
	harm = Control.names(\harm).kr(Array.series(4, 1, 1));
	// amplitudes
	amp = Control.names(\amp).kr(Array.fill(4, 0.05));
	// ring times
	ring = Control.names(\ring).kr(Array.fill(4, 1));
	klank = DynKlank.ar(`[harm, amp, ring], {ClipNoise.ar(0.003)}.dup, freq);
	Out.ar(out, klank);
}).add
)
