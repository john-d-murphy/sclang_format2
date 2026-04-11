// Source: Classes/Function.schelp block 34 (part 4/5)
z = { WhiteNoise.ar * 0.1 }.play; // play some noise
{ BPF.ar(In.ar(0), 7000, 0.01) * 10 }.loadToFloatArray(0.01, z, action: { arg array; a = array });
