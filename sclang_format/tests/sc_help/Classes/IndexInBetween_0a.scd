// Source: Classes/IndexInBetween.schelp block 0 (part 1/6)
(
// autotune.
{
	var index, in, autotuned, f0, fdiff;
	var scale = ([0, 1, 3, 4, 7, 11, 12] + 70).midicps;
	var buffer = scale.as(LocalBuf);
	in = Pulse.ar(MouseX.kr(scale.minItem, scale.maxItem)) * 0.1;
	f0 = Pitch.kr(in).at(0);
	index = IndexInBetween.kr(buffer, f0);
	fdiff = index.frac * (Index.kr(buffer, index + 1) - Index.kr(buffer, index));
	autotuned = PitchShift.ar(in, 0.1, 1 - (fdiff / f0), 0.01, 0.01);
	RLPF.ar(autotuned, [2000, 5000], 0.3)
}.play;
)
