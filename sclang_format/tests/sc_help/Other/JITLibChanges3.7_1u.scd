// Source: Other/JITLibChanges3.7.schelp block 1 (part 21/22)
Ndef(\y, { Impulse.ar([1, 2/3, 4/6, 2, 9/8] * 100 * DelayC.ar(Ndef.ar(\aa) + 1, 0.5, LFNoise1.kr(3 ! 2).range(0, 0.5), 1, Ndef(\aa)), [0.1, 0.1]/2) });
