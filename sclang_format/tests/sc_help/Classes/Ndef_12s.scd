// Source: Classes/Ndef.schelp block 12 (part 19/24)
(
Ndef(\filter, {
	HPF.ar(
		\in.ar(0!~numChans),
		SinOsc.ar({|i| 2 + i}!~numChans) + 1 * \multFreq.kr(Array.geom(~numChans, 400, 2))
	)
}).mold(~numChans, \audio, \elastic);
)
