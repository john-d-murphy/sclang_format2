// Source: Classes/Klank.schelp block 3 (part 1/14)
(
SynthDef(\help_Klank, { arg out=0, i_freq;
	var klank, n, harm, amp, ring;

	// harmonics
	harm = \harm.ir(Array.series(4, 1, 1).postln);
	// amplitudes
	amp = \amp.ir(Array.fill(4, 0.05));
	// ring times
	ring = \ring.ir(Array.fill(4, 1));

	klank = Klank.ar(`[harm, amp, ring], {ClipNoise.ar(0.003)}.dup, i_freq);

	Out.ar(out, klank);
}).add;
)
