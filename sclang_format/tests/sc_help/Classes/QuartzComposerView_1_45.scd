// Source: Classes/QuartzComposerView.schelp block 1 (part 46/76)
(
// convert to array
y = Array.newClear(x.size);
x.keysValuesDo({ |i, elem| y[i.asInteger] = elem });
y.postln;
)
