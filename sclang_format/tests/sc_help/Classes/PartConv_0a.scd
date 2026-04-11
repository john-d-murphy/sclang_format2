// Source: Classes/PartConv.schelp block 0 (part 1/6)
(

 // also 4096 works on my machine; 1024 too often and amortisation too pushed, 8192 more high load FFT
~fftsize = 2048;

s.waitForBoot {

	{
		var ir, irbuffer, bufsize;

		// // MONO ONLY
		// pre-existing impulse response sound files
		// (could also use any general soundfile too for cross-synthesis effects)
		// irbuffer = Buffer.read(s, "/Volumes/data/audio/ir/ir2.wav");

		// synthesise the honourable 'Dan Stowell' impulse response

		ir = [1] ++ 0.dup(100) ++ (
			(1, 0.99998 .. 0)
			.collect {|f|
				f = f.squared.squared;
				f = if(f.coin) { 0 }{ f.squared };
				f = if(0.5.coin) { 0 - f } { f }
			} * 0.1
		);
		ir = ir.normalizeSum;

		irbuffer = Buffer.loadCollection(s, ir);

		s.sync;

		bufsize = PartConv.calcBufSize(~fftsize, irbuffer);

		// ~numpartitions= PartConv.calcNumPartitions(~fftsize, irbuffer);

		~irspectrum = Buffer.alloc(s, bufsize, 1);
		~irspectrum.preparePartConv(irbuffer, ~fftsize);

		s.sync;

		irbuffer.free; // don't need time domain data anymore, just needed spectral version
	}.fork;

}
)
