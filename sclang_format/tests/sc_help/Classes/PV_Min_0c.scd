// Source: Classes/PV_Min.schelp block 0 (part 3/4)
(
var exBuf;
Dialog.getPaths({ arg paths; //get a second soundfile;
	paths.do({ arg p; exBuf = Buffer.read(s, p);
		SynthDef("help-min", { arg out=0, soundBufnum1=2, soundBufnum2 = 3;
			var inA, chainA, inB, chainB, chain ;
			inA = PlayBuf.ar(1, soundBufnum1, BufRateScale.kr(soundBufnum1), loop: 1);
			inB =  PlayBuf.ar(1, soundBufnum2, BufRateScale.kr(soundBufnum2), loop: 1);
			chainA = FFT(LocalBuf(2048), inA);
			chainB = FFT(LocalBuf(2048), inB);
			chain = PV_Min(chainA, chainB);
			Out.ar(out,  0.1 * IFFT(chain).dup);
		}).play(s,[\soundBufnum1, b.bufnum, \soundBufnum2, exBuf.bufnum]);
	})
},{
	"cancelled".postln;
});
)
