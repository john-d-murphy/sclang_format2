// Source: Classes/ToggleFF.schelp block 0
(
play({
	SinOsc.ar((ToggleFF.ar(Dust.ar(XLine.kr(1,1000,60))) * 400) + 800, 0, 0.1)
}))
