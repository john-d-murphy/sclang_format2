// Source: Classes/PV_Div.schelp block 0 (part 2/3)
(
x = {
	// Any input should theoretically be OK, white noise is a good choice
	var son = WhiteNoise.ar;
//	var son = Impulse.ar;
	var out = LPF.ar(son, MouseX.kr(100, 10000, 1));
	var fft1 = FFT(LocalBuf(b.numFrames), son, wintype: 1);
	var fft2 = FFT(b, out, wintype: 1);

	// As with most PV_ ugens, the result is *actually* stored in the first fft buf
	var result = PV_Div(fft2, fft1);

	out.dup * 0.1
}.play;
)
