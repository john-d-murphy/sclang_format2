// Source: Classes/NodeProxy.schelp block 17 (part 3/3)
(
a.source = { |freq = 440, rate = 2|
	SinOsc.ar(freq * [1, 1.625]) * SinOsc.kr(rate).max(0) * 0.2
}
);
