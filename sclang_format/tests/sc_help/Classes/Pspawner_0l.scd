// Source: Classes/Pspawner.schelp block 0 (part 12/17)
(
c = Spawner({ |sp|
	100.do{ sp.wait(1) }
});
b = c.par(				// now start a pattern in spawner
	Pbind(*[degree: Pseq((0..6) ++ (7..1), inf), dur: 0.2])
);
c.play;					// in this case, c is always valid
)
