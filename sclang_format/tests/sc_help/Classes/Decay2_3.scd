// Source: Classes/Decay2.schelp block 3
(
var t60, riseScale, riseFac, normFac;

t60 = 0.01;
riseScale = [0.0, 0.2, 0.5, 0.9];
riseFac = riseScale / (2 - riseScale);
normFac = riseFac.pow(riseFac / (riseFac - 1)) / (1 - riseFac);

// Plot in dB to inspect decay time
plot(
    {
        Decay2.ar(Impulse.ar(0),
            attackTime: t60 * riseFac,
            decayTime: t60,
            mul: normFac
        ).ampdb.max(-120) // to dB, clip -inf
    },
    duration: t60, minval: -60
).superpose_(true)
.axisLabelY_("dB")
.axisLabelX_("Time (s)")
)
