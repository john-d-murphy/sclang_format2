// Source: Classes/AbstractGridLines.schelp block 3
(
var g = GridLines([0, 10000].asSpec);
"in val / rounded / not rounded".postln;
10.collect{ 10000.rand }.sort.do({ |x|
    postf("% / % / %\n", x, g.niceNum(x, true), g.niceNum(x, false))
})
)
