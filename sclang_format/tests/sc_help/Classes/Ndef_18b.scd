// Source: Classes/Ndef.schelp block 18 (part 2/5)
(
Ndef(\sound, { |freq = 440, rate = 2|
	SinOsc.ar(freq * [1, 1.625]) * SinOsc.kr(rate).max(0) * 0.2
}).play;
)
