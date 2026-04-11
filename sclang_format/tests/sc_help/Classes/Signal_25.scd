// Source: Classes/Signal.schelp block 25
(
var size = 512;
var real, imag, cosTable, frqAmpPhs, complex;

// Create a signal of sine partials:
// partial freqs, amps, and phases
frqAmpPhs = [
	// 0 Hz (DC), amp: 1, phase pi/2 (cosine)
	[0, 1, 0.5pi],
	// other partials, various amp and phase
	[8], [13, 0.25], [21, 0.25], [55, 0.5, 0.5pi],
	// nyquist, amp: 1, phase pi/2 (cosine)
	[size/2, 1, 0.5pi]
];
real = Signal.newClear(size);
real.sineFill2(frqAmpPhs);

imag = Signal.newClear(size); // zeros
cosTable = Signal.fftCosTable(size);

// Perform fft
complex = fft(real, imag, cosTable);

// Plot signals and spectrum
[
	real,
	imag,
	(complex.magnitude) / size
]
.plot("fft", Window.screenBounds.insetBy(*200!2))
.axisLabelX_(["Signal (real, samples)", "Signal (imaginary, samples)", "FFT spectrum (bins)"])
.axisLabelY_(["Amplitude", "Amplitude", "Magnitude"])
.plotMode_([\linear, \linear, \steps]);
)
