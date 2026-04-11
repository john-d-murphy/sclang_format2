// Source: Classes/VarLag.schelp block 1 (part 1/6)
(
x = play { |amp=0, time=0, curve=0, warp=5|
    PinkNoise.ar(VarLag.kr(amp, time, curve, warp) ! 2)
}
)
