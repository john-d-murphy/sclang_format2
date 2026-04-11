// Source: Classes/OSCBundle.schelp block 0 (part 2/13)
x = SynthDef("test", { OffsetOut.ar(0, BPF.ar(Impulse.ar(4) * 10, Rand(9000, 1000), 0.1)) });
