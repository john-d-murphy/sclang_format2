// Source: Classes/NodeProxy.schelp block 14 (part 2/8)
(
Ndef(\out).mold(2, \audio, \elastic);
Ndef(\out)[0] = {
	// 5 channel input
	Splay.ar(\in.ar(0!5), level: \amp.kr(0.3))
}
)
