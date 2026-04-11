// Source: Tutorials/JITLib/proxyspace_examples.schelp block 2 (part 1/4)
~out = { arg rate = 2; Pan2.ar(PinkNoise.ar(0.1), LFClipNoise.kr(rate)) };
