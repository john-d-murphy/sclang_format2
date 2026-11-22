// Source: Classes/SynthDef.schelp block 7 (part 1/6)
(
SynthDef(\arrayarg, { |out, amp = 0.1, gate = 1|
	var env, sines;
	var freqs = NamedControl.kr(\freqs, [300, 400, 500, 600]);
	env = Linen.kr(gate, 0.1, 1, 1, 2) * amp;
	sines = SinOsc.ar(freqs +.t [0, 0.5]).cubed.sum; // A mix of 4 oscillators
	Out.ar(out, sines * env);
}, [0, 0.1, 0]).add;
)
