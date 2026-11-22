// Source: Classes/Decay2.schelp block 1
(
plot({
    var attack = 0.001, decay = 0.01;
    var imp = Impulse.ar(0);
    [
        Decay2.ar(imp, attack, decay),
        Decay2.ar(imp, decay, attack)
    ]
}, duration: 0.01).superpose_(true)
)
