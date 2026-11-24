// Source: Classes/DynKlank.schelp block 1 (part 1/12)
(
// change freqs and ringtimes with mouse
{	var freqs, ringtimes;
	freqs = [800, 1071, 1153, 1723] * MouseX.kr(0.5, 2, 1);
	ringtimes = [1, 1, 1, 1] * MouseY.kr(0.1, 10, 1);
	DynKlank.ar(`[freqs, nil, ringtimes], Impulse.ar(2, 0, 0.1))
}.play;
)
