// Source: Classes/DetectSilence.schelp block 0
{ var signal = Decay.ar(Impulse.ar(0), 2, PinkNoise.ar(0.2)); DetectSilence.ar(signal, doneAction: Done.freeSelf); signal }.play;
