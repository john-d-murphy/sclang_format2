// Source: Classes/PV_ConformalMap.schelp block 3 (part 4/6)
(
SynthDef("conformer1", { |out|
	var in, chain;
	in = SoundIn.ar(0, 0.5);
	chain = FFT(LocalBuf(1024), in);
	chain = PV_ConformalMap(chain, MouseX.kr(-1.0, 1.0), MouseY.kr(-1.0, 1.0));
	Out.ar(out, Pan2.ar(IFFT(chain), 0));
}).add;
)
