// Source: Classes/Server.schelp block 14 (part 6/13)
(
s.makeBundle(nil, { // nil executes ASAP
	y = { SinOsc.kr(0.2).abs }.play(x, 0, 0, \addBefore); // sine envelope
}, b);
)
