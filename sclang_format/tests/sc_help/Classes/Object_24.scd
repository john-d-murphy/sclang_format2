// Source: Classes/Object.schelp block 24
(
var x, z;
z = [0, 1, 1.1, 1.3, 1.5, 2];
switch (z.choose.postln,
	1,   { \no },
	1.1, { \wrong },
	1.3, { \wrong },
	1.5, { \wrong },
	2,   { \wrong },
	0,   { \true }
).postln;
)
