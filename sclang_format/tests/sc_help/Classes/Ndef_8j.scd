// Source: Classes/Ndef.schelp block 8 (part 10/12)
Ndef(\sound, { |freq| SinOsc.ar([600, 635] + freq, 0, SinOsc.kr(2 * 3).max(0) * 0.2) });
