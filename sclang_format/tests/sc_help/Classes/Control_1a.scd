// Source: Classes/Control.schelp block 1 (part 1/17)
(
SynthDef(\help_Control, { arg out=0, i_freq;
	var klank, harm, amp, ring;

	// harmonics
	harm = Control.names([\harm]).ir(Array.series(4, 1, 1).postln);
	// amplitudes
	amp = Control.names([\amp]).ir(Array.fill(4, 0.05));
	// ring times
	ring = Control.names([\ring]).ir(Array.fill(4, 1));

	klank = Klank.ar(`[harm, amp, ring], { ClipNoise.ar(0.01) }.dup, i_freq);

	Out.ar(out, klank);
}).add;
)
