// Source: Classes/Ndef.schelp block 12 (part 1/11)
(
Ndef(\sound, {
	RHPF.ar(
		\in1.ar([0, 0]) * \in2.ar([0, 0]),
		\freq.kr(6000, 2),
		\rq.kr(0.2)
	) * 7
}).play;
Ndef(\sound).fadeTime = 0.2;	// avoid harsh clicks
)
