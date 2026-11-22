// Source: Classes/BeatTrack2.schelp block 5 (part 1/3)
(
var startbps = 1, endbps = 3;
var numtempi = 100;
var ratio, tempi, periods;

ratio = (endbps / startbps) ** (numtempi-1).reciprocal;

tempi = Array.geom(numtempi, startbps, ratio);

periods = tempi.reciprocal;

Post << (tempi*60) << nl;
Post << periods << nl;
)
