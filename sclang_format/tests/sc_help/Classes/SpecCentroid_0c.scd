// Source: Classes/SpecCentroid.schelp block 0 (part 3/4)
(
x = {
	var in, chain, freq, rq, centroid;

	//freq = LFPar.kr(0.3).exprange(100, 1000);
	freq = MouseY.kr(1000, 100, 1);
	in = Blip.ar(freq, MouseX.kr(1, 100, 1));
	chain = FFT(LocalBuf(2048), in);
	centroid = SpecCentroid.kr(chain);
	centroid.poll(10);
	in.dup * 0.1

}.play
)
