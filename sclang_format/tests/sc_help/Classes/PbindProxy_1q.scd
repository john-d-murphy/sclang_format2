// Source: Classes/PbindProxy.schelp block 1 (part 17/18)
(
x.set(\degree, Pseq([1b, 5, 3, 1b, 6, 2, 5, 0, 3, 0, 2], inf));
Ppar([
x,
Pbindf(x, \ctranspose, 4)
]).play;
)
