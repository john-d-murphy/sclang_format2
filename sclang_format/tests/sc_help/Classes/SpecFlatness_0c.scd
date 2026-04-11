// Source: Classes/SpecFlatness.schelp block 0 (part 3/3)
(
{ // Now try with your own voice
	var in, chain;
	in = SoundIn.ar([0,1]).mean;
	chain = FFT(LocalBuf(2048), in);
	Out.kr(0, [in, SpecFlatness.kr(chain).poll(1, "flatness: ")]);
}.scope;
)
