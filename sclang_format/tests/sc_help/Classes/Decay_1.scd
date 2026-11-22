// Source: Classes/Decay.schelp block 1
(
play({
    Decay.ar(
        in: Impulse.ar(XLine.kr(5,50,10), 0.25),
        decayTime: 0.2,
        mul: FSinOsc.ar(300)
    )
})
)
