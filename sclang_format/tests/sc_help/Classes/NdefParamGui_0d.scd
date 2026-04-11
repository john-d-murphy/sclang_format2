// Source: Classes/NdefParamGui.schelp block 0 (part 4/20)
Ndef(\a, { |freq = 300, amp = 0.2| SinOsc.ar(freq) * amp ! 2 }).play;
