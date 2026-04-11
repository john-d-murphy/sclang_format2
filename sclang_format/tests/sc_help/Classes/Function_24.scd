// Source: Classes/Function.schelp block 24
(
var i, x, z;
z = [0, 1, 1.1, 1.3, 1.5, 2];
i = z.choose;
x = case
	{ i == 1 }   { \no }
	{ i == 1.1 } { \wrong }
	{ i == 1.3 } { \wrong }
	{ i == 1.5 } { \wrong }
	{ i == 2 }   { \wrong }
	{ i == 0 }   { \true };
x.postln;
)
