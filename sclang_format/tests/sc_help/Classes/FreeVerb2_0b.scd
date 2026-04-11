// Source: Classes/FreeVerb2.schelp block 0 (part 2/7)
(
SynthDef(\FreeVerb2x2, { |out, mix = 0.25, room = 0.15, damp = 0.5, amp = 1.0|
	var signal;

	signal = In.ar(out, 2);

	ReplaceOut.ar(out,
		FreeVerb2.ar( // FreeVerb2 - true stereo UGen
			signal[0], // Left channel
			signal[1], // Right Channel
			mix, room, damp, amp
		)
	); // same params as FreeVerb 1 chn version

}).add;
)
