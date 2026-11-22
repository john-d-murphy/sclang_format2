// Source: Classes/SpecPcile.schelp block 0 (part 1/2)
(
{
	var in, chain, realcutoff, estcutoff;
	realcutoff = MouseX.kr(0.00001, 22050);
	in = LPF.ar(WhiteNoise.ar, realcutoff);
	chain = FFT(LocalBuf(2048), in);
	estcutoff = Lag.kr(SpecPcile.kr(chain, 0.9), 1);
	realcutoff.poll(Impulse.kr(1), "real cutoff");
	estcutoff.poll(Impulse.kr(1), "estimated cutoff");
	Out.kr(0, estcutoff * 22050.0.reciprocal);
	Out.ar(0, in);
}.scope;
)
