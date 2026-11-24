// Source: Classes/EventStreamCleanup.schelp block 0
(
f = { |pat, condition|
	Prout { |inval|
		var stream = pat.asStream;
		var cleanup = EventStreamCleanup.new;
		var outval;
		while {
			outval = stream.next(inval);
			outval.notNil and: { condition.value(outval) }
		} {
			cleanup.update(outval);
			inval = outval.yield;
		};
		cleanup.exit(inval);
	}

};
p = Plazy { Pmono(\default, \note, Pgeom(rrand(1, 1.5), rrand(1.05, 2), inf), \harmonic, [0.78, 1, 1.2], \dur, 1/rrand(4, 7), \amp, 0.4) };
x = f.(p, { |outval| outval[\note] < 20 }); // always stop at 20
Pn(x).play; // loop it.
);
