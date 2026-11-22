// Source: Classes/DynKlank.schelp block 1 (part 2/12)
(
// set them from outside later:
SynthDef('help-dynKlank', { |out|
	var freqs, ringtimes, signal;
	freqs = Control.names([\freqs]).kr([800, 1071, 1153, 1723]);
	ringtimes = Control.names([\ringtimes]).kr([1, 1, 1, 1]);
	signal = DynKlank.ar(`[freqs, nil, ringtimes], Impulse.ar(2, 0, 0.1));
	Out.ar(out, signal);
}).add;
)
