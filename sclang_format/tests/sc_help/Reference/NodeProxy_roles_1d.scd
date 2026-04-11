// Source: Reference/NodeProxy_roles.schelp block 1 (part 4/6)
(
a[1] = \set -> Pbind(
	\dur, Prand([1, 0.5], inf),
	\freq, Pwhite(200.0, 1000, inf),
	\rate, Pdup(4, Prand([1, 3, 6, 10], inf)),
	\dt, Pwhite(0.01, 0.1, inf)
)
);
