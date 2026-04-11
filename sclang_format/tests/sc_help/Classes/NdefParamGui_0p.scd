// Source: Classes/NdefParamGui.schelp block 0 (part 16/20)
Ndef(\a, { |freqs = #[300, 303], pan, amp = 0.2| SinOsc.ar(freqs).sum * amp });
