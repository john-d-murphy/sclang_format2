// Source: Classes/SendReply.schelp block 0 (part 5/9)
(
SynthDef(\amplitudeAnalysis, { |in = 0, rate = 60|
	var input = SoundIn.ar(in);
	var amp = Amplitude.kr(input);
	var freq = Pitch.kr(input);
	var trig = Impulse.kr(rate);
	SendReply.kr(trig, '/analysis', [amp, freq[0], freq[1]]);
}).add;
)
