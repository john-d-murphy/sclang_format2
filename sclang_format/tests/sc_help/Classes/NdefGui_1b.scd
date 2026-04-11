// Source: Classes/NdefGui.schelp block 1 (part 2/7)
(
Ndef(\lfo, { |lofreq| SinOsc.kr(lofreq) });
Ndef(\a, { |freq=300, dens=20, amp=0.1, pan|
	Pan2.ar(Ringz.ar(Dust.ar(dens, amp / (dens.max(1).sqrt)), freq, 0.2), pan)
});
)
