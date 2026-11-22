// Source: Classes/Wavetable.schelp block 1 (part 6/9)
(
s.waitForBoot({
	var amplitudes = [0, 1, 1, -2, 1];
	var wavs = [
		Wavetable.chebyFill(256+1, amplitudes, normalize: true, zeroOffset: true),
		Wavetable.chebyFill(256+1, amplitudes, normalize: true, zeroOffset: false)
	];
	b = wavs.collect{ |wav| Buffer.loadCollection(s, wav) };
	s.sync;
	x = {
		var in = SinOsc.ar(100, 0, SinOsc.kr(0.1, 0, 0.5, 0.5));
		Shaper.ar(b, in) ++ LeakDC.ar(Shaper.ar(b[1], in))
	}.scope;
})
)
