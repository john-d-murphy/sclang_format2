// Source: Reference/Control-Structures.schelp block 18
(
var i, x, z;
z = [0, 1, 2];
i = z.choose;
x = case(
	{ i == 2 }, { \wrong },
	{ i == 0 }, { \true },
	{ \defaultFunction }
);
[i, x].postln;
)
