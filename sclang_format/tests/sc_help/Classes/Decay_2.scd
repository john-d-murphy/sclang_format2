// Source: Classes/Decay.schelp block 2
(
plot({
    Decay.ar(
        in: Impulse.ar(50),
        decayTime: 0.015,
        mul: FSinOsc.ar(370)
    )
}, 0.1, bounds: Rect(50,50,1200,400))
)
