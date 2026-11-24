// Source: Guides/FFT-Overview.schelp block 9 (part 3/4)
(
Routine({
	3.do{arg i;
		c.getToFloatArray(action: { arg array;
			var z, x;
			z = array.clump(2).flop;
			// Initially data is in complex form
			z = [Signal.newFrom(z[0]), Signal.newFrom(z[1])];
			x = Complex(z[0], z[1]);

			{ x.magnitude.plot('Initial', Rect(200, 600-(200*i), 700, 200)) }.defer
		});
		0.1.wait;
}}).play
)
