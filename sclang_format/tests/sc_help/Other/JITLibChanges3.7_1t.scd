// Source: Other/JITLibChanges3.7.schelp block 1 (part 20/22)
Ndef(\y, { Impulse.ar([1, 2/3, 4/6, 2, 3] * 100 * DelayC.ar(Ndef.ar(\aa) + 1, 0.5, LFNoise1.kr(0.1 ! 4).range(0, 0.5), 1, Ndef.ar(\aa)), [0.1, 0.1]/2) });
