// Source: Classes/Warp1.schelp block 0 (part 3/6)
(
// a custom envelope - not a very good one, but you can hear the difference
// between this and the default
var winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);
x.set(\envbuf, z);
)
