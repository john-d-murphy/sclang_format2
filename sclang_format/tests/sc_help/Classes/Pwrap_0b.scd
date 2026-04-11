// Source: Classes/Pwrap.schelp block 0 (part 2/2)
(
a = Pn(
	Pwrap(
		Pgeom(200,1.07,96),
		200,
		1000.0
	),
	inf
);
x = a.asStream;

Routine({
	loop({
		Synth(\help_sinegrain, [\freq, x.next.debug,\dur,0.3]);
		0.12.wait;
	})
}).play;
)
