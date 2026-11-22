// Source: Classes/Onsets.schelp block 0 (part 3/5)
(
var threshes = (0.1, 0.2 .. 1);
x = {
	var sig, chain, onsets, pips;

	// A simple generative signal
	sig = LPF.ar(Pulse.ar(TIRand.kr(63, 75, Impulse.kr(2)).midicps), LFNoise2.kr(0.5).exprange(100, 10000)) * Saw.ar(2).range(0, 1);
	// or, uncomment this line if you want to play the buffer in
	// sig = PlayBuf.ar(1, d, BufRateScale.kr(d), loop: 1);

	chain = FFT(LocalBuf(512), sig);

	onsets = Onsets.kr(chain, threshes, \rcomplex);

	// Generate pips at a variety of pitches
	pips = SinOsc.ar((threshes).linexp(0, 1, 440, 3520), 0, EnvGen.kr(Env.perc(0.001, 0.1, 0.5), onsets)).mean;
	Pan2.ar(sig, -0.75, 0.2) + Pan2.ar(pips, 0.75, 1)
}.play;
)
