// Source: Classes/Function.schelp block 33 (part 2/2)
{ PlayBuf.ar(b.numChannels, b, LFNoise2.kr(2 ! 8).exprange(0.15, 1), loop:1).sum }.play;
