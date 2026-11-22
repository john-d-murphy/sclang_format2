// Source: Classes/SpecPcile.schelp block 0 (part 2/2)
(
{
	var in, chain, perc;
	in = SoundIn.ar([0, 1]).mean;
	chain = FFT(LocalBuf(2048), in);
	// Out.ar(0, in * 0.1);
	perc = SpecPcile.kr(chain, 0.5);
	Out.kr(0, perc * 22050.0.reciprocal);
	Out.ar(1, LPF.ar(WhiteNoise.ar, perc)); // outputting to right channel
}.scope;
)
