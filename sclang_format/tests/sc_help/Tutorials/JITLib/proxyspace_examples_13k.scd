// Source: Tutorials/JITLib/proxyspace_examples.schelp block 13 (part 11/35)
~out = { arg freq=300, ffreq=20; BPF.ar(LFSaw.ar(ffreq * [1, 1.1], 0, 1), freq, 0.2) };

~lfo = { FSinOsc.kr(0.3, 0, 30, 200) + FSinOsc.kr(10, 0, 10) };
