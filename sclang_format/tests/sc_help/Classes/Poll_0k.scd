// Source: Classes/Poll.schelp block 0 (part 11/13)
(
{
var cutoff, son;
cutoff = LFPar.kr(0.2, 0, 500, 500);
son = LPF.ar(WhiteNoise.ar, cutoff);

// Using Poll to debug by spitting out a value if the output hits NaN
Poll.ar(if((son<=0)||(son>=0), 0, 1), cutoff, "Cutoff value which causes NaN:");

son;

}.play(s);
)
