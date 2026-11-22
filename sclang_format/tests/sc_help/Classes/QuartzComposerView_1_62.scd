// Source: Classes/QuartzComposerView.schelp block 1 (part 63/76)
(
a = { FFT(b, LFSaw.ar(4000)); 0.0 }.play; // sawtooth

p = 0.25; i = 0;
// m.setInputValue(\period, p);
// m.maxFPS_(p.reciprocal * 2);
SystemClock.sched(0.0, {
b.getn(0, 256, { |buf|
	var z, x;
	z = buf.clump(2).flop;
	z = [Signal.newFrom(z[0]), Signal.newFrom(z[1])];
	x = Complex(z[0], z[1]);
	// { m.setInputValue(\magnitudes, x.magnitude.resamp1(m.bounds.height * 0.5)) }.defer
	{ m.setInputValue(\magnitudes, x.magnitude * 0.025); m.setInputValue(\count, i) }.defer;
	i = i + 1;
}); p
});
)
