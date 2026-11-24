// Source: Other/JITLibChanges3.7.schelp block 2 (part 466/815)
Ndef(\y, { Ndef.ar(\x).collect { |x| x * SinOsc.ar(exprand(3.0, 3000)) * LFPulse.kr(rrand(10, 50)) } }).play(0, 2);
