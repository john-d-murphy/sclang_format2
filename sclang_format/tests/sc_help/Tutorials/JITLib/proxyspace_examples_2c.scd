// Source: Tutorials/JITLib/proxyspace_examples.schelp block 2 (part 3/4)
~out = { arg rate = 2; Pan2.ar(Dust.ar(2000, 0.2), LFClipNoise.kr(rate)) };
