// Source: Classes/VOsc3.schelp block 0 (part 1/7)
(
s.waitForBoot({

	var numBufs = 8;

	// allocate table of consecutive buffers
	~bufs = Buffer.allocConsecutive(numBufs, s, 1024, 1);
	s.sync;

	~bufs.do({ |buf, i|
		var n, a;

		// generate array of harmonic amplitudes
		n = (i+1)**2;
		a = Array.fill(n, { |j| ((n-j)/n).squared.round(0.001) });

		// fill table
		// argument '7': flag for the \sine1 wave fill method
		// see "Wave Fill Commands" in the Server Command Reference
		s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);

		s.sync;
	});
	"Buffers prepared.".postln;
})
)
