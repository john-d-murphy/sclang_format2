// Source: Tutorials/JITLib/proxyspace_examples.schelp block 13 (part 12/38)
~out = { arg freq=300, ffreq=20; BPF.ar(LFSaw.ar(ffreq * [1, 1.1], 0, 1), freq, 0.2) };
