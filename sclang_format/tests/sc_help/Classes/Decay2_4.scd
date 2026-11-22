// Source: Classes/Decay2.schelp block 4
(
var t60, riseScale, riseFac, riseTime, maxRiseTime;

t60 = 0.3; // decay time
riseScale = 0.1;

riseFac = riseScale / (2 - riseScale);
maxRiseTime = t60 * 60.dbamp.log.reciprocal;
riseTime = maxRiseTime * (riseFac * riseFac.log) / (riseFac - 1);

postf(
    "For decayTime = % sec, the max possible rise time is % sec.\n"
    "When riseScale = %, the rise time is % sec.\n",
    *round([t60, maxRiseTime, riseScale, riseTime], 0.001)
);""
)
