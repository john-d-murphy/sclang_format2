// Source: Classes/Signal.schelp block 26
(
var real, imag, cosTable, complex, ifft;
var size = 512;

// Create a signal of sine partials, add noise
real = Signal.newClear(size);
real.sineFill2([[8], [13, 0.5], [21, 0.25], [55, 0.125, 0.5pi]]);
real.overDub(Signal.fill(size, { 0.2.bilinrand }));

imag = Signal.newClear(size); // zeros
cosTable = Signal.fftCosTable(size);

// Perform fft & ifft
complex = fft(real, imag, cosTable).postln;
ifft = complex.real.ifft(complex.imag, cosTable);

// Plot input and output
[
	real,
	ifft.real
]
.plot("fft -> ifft", Window.screenBounds.insetBy(*200!2))
.axisLabelX_(["Real signal (samples)", "Restored signal (samples)"])
.axisLabelY_("Amplitude");
)
