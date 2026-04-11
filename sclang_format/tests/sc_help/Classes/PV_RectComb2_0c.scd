// Source: Classes/PV_RectComb2.schelp block 0 (part 3/3)
(
var exBuf;
Dialog.getPaths({ arg paths; //get a second soundfile;
	paths.do({ arg p; exBuf = Buffer.read(s, p);

		SynthDef("help-max", { arg out=0, soundBufnum1=2, soundBufnum2 = 3;
			var inA, chainA, inB, chainB, chain ;
			inA = PlayBuf.ar(1, soundBufnum1, BufRateScale.kr(soundBufnum1), loop: 1);
			inB =  PlayBuf.ar(1, soundBufnum2, BufRateScale.kr(soundBufnum2), loop: 1);
			chainA = FFT(LocalBuf(2048), inA);
			chainB = FFT(LocalBuf(2048), inB);
			chain = PV_RectComb2(chainA, chainB,  MouseX.kr(0, 32), MouseY.kr, 0.3);
			Out.ar(out,  0.5 * IFFT(chain).dup);
		}).play(s, [\soundBufnum1, b, \soundBufnum2, exBuf]);
	})
},{
	"cancelled".postln;
});
)
