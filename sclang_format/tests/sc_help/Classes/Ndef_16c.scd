// Source: Classes/Ndef.schelp block 16 (part 3/7)
Ndef(\sound -> \foo, { SinOsc.ar([700, 745]) * SinOsc.kr(2).max(0) * 0.2 }).play;
