// Source: Classes/PV_PhaseShift90.schelp block 0 (part 2/2)
(
{ |out=0, bufnum=0|
	var in, fft, fft2, shifted;
	in = SinOsc.ar(500, 0, 0.1);
	fft = FFT(LocalBuf(2048), in);
	fft2 = FFT(LocalBuf(2048), in);
	shifted = PV_PhaseShift90(fft);
	Out.ar(out, [IFFT(fft2), IFFT(shifted)]);
}.scope
)
