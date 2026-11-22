// Source: Classes/Signal.schelp block 1 (part 6/9)
(
s.waitForBoot({
	var amplitudes = [0, 1, 1, -2, 1];
	var sigs = [
		Signal.chebyFill(256+1, amplitudes, normalize: true, zeroOffset: true),
		Signal.chebyFill(256+1, amplitudes, normalize: true, zeroOffset: false)
	];
	b = sigs.collect{ |sig| Buffer.loadCollection(s, sig.asWavetableNoWrap) };
	s.sync;
	x = {
		var in = SinOsc.ar(100, 0, SinOsc.kr(0.1, 0, 0.5, 0.5));
		Shaper.ar(b, in) ++ LeakDC.ar(Shaper.ar(b[1], in))
	}.scope;
})
)
