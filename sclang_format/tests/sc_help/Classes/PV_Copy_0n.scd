// Source: Classes/PV_Copy.schelp block 0 (part 14/15)
(
~allBuffers.keysValuesDo { |name, buffer, i|
	buffer.getToFloatArray(action: { |array|
		var z, x;
		// Initially, data is in complex form
		z = array.clump(2).flop;
		z = z.collect { |each| Signal.newFrom(each) };
		x = Complex(z[0], z[1]);
		{ x.magnitude.plot(name, Rect(200, 100 + (230 * i), 700, 200)) }.defer
	});
}
)
