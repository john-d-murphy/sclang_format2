// Source: Classes/NodeProxy.schelp block 11 (part 3/6)
a.source = { BPF.ar(Impulse.ar({ rrand(1.0, 2.0) } ! a.numChannels), (0..5).nthPrime * 300, 0.01) * 20 };
