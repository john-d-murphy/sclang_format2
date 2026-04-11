// Source: Classes/DrawGrid.schelp block 0
(
g = GridLines([0, 200].asSpec);
"requested / returned".postln;
(0, 3 .. 21).do({ |ntck|
  "% / %\n".postf(ntck, g.niceNum(ntck, true))
})
)
