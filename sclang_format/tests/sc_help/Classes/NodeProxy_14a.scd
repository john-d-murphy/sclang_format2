// Source: Classes/NodeProxy.schelp block 14 (part 1/8)
(
Ndef(\sin).mold(5, \audio, \elastic);
Ndef(\sin)[0] = {
	SinOsc.ar(
		\freq.kr([200, 201, 202, 204, 205]),
		SinOsc.kr(\phase.kr([0, 0, 0, 0, 0])).range(0, 2pi)
	)
}
)
