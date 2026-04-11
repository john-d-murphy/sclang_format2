// Source: Tutorials/JITLib/proxyspace_examples.schelp block 18 (part 8/11)
~out = { BPF.ar(~someInput.ar, MouseX.kr(100, 18000, 1), 0.1) };

~out = { CombL.ar(~someInput.ar * (LFNoise0.ar(2) > 0), 0.2, 0.2, MouseX.kr(0.1, 5, 1)) };

~out = { RLPF.ar(~someInput.ar, LFNoise1.kr(3, 1000, 1040), 0.05) };


t.stop;
