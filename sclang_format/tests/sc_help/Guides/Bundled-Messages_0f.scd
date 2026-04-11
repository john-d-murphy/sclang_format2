// Source: Guides/Bundled-Messages.schelp block 0 (part 6/8)
(
s.makeBundle(nil, { // nil executes ASAP
	y = { SinOsc.kr(0.2).abs }.play(x, 0, 0, \addBefore); // sine envelope
}, b);
)
