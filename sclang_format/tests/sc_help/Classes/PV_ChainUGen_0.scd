// Source: Classes/PV_ChainUGen.schelp block 0
(
{
	var chain = FFT(LocalBuf(1024));
	chain.fftSize.poll;
	0.0
}.play;
)
