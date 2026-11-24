// Source: Classes/QuartzComposerView.schelp block 1 (part 68/76)
(
m.setInputValue(\framesPerView, 50);
a = { var colum;
	colum = PlayBuf.ar(1, c, BufRateScale.kr(c) * Line.kr(1, 3, 20), loop: 1);
	FFT(b, colum);
	colum
}.play;
)
