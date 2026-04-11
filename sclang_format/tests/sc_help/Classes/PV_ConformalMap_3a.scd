// Source: Classes/PV_ConformalMap.schelp block 3 (part 1/4)
(
SynthDef("conformer2", { |out|
	var in, chain, sound;
	in = Mix.ar(LFSaw.ar(SinOsc.kr(Array.rand(3,0.1,0.5),0,10,[1,1.1,1.5,1.78,2.45,6.7]*220),0,0.3));
	chain = FFT(LocalBuf(2048), in);
	chain = PV_ConformalMap(chain, MouseX.kr(0.01,2.0, 'exponential'), MouseY.kr(0.01,10.0, 'exponential'));
	sound = IFFT(chain);

	Out.ar(out, Pan2.ar(CombN.ar(sound, 0.1, 0.1, 10, 0.5, sound), 0, 0.3));
}).add;
)
