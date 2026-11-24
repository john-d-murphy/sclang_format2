// Source: Classes/Decay2.schelp block 2
(
var t60, riseScale, riseFac, normFac;

// Approximate 60 dB decay time
// (actual t60 will increase with riseScale)
t60 = 0.01;

// Scale the rise time (< 1.0)
riseScale = 0.1;

// Calculate normalization factor
riseFac = riseScale / (2 - riseScale);
normFac = riseFac.pow(riseFac / (riseFac - 1)) / (1 - riseFac);

// Plot and compare to Decay
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
}, duration: t60)
.plotColor_([Color.blue, Color.red])
.superpose_(true)
)
