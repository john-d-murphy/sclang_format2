// Source: Classes/Decay.schelp block 3
(
var t60, riseScale, riseFac, normFac;

t60 = 0.3; // decay time

// Onset control and normalization factor for Decay2
// (See Decay2 Help doc for more info)
riseScale = 0.3;
riseFac = riseScale / (2 - riseScale);
normFac = riseFac.pow(riseFac / (riseFac - 1)) / (1 - riseFac);

// Compare Decay (blue) and Decay2 (red)
plot({
    var imp = Impulse.ar(0);
    [
        Decay.ar(imp, t60),
        Decay2.ar(imp,
            attackTime: t60 * riseFac,
            decayTime: t60,
            mul: normFac
        )
    ]
}, duration: t60/2)
.plotColor_([Color.blue, Color.red])
.superpose_(true)
)
