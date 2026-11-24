// Source: Reference/NodeProxy_roles.schelp block 4 (part 4/7)
(
a[0] = \setbus -> Pbind(
	\dur, Prand([1, 0.5], inf),
	\value, Pfunc { var z = rrand(300, 4000); [300, 400, z, z + 30.rand2] }
)
);
