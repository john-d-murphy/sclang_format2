// Source: Classes/Buffer.schelp block 1 (part 2/4)
(
b = Buffer.allocConsecutive(8, s, 4096, 1, { |buf, i|
	buf.sine1Msg((1..((i+1)*6)).reciprocal) // completion Messages
});

a = { VOsc.ar(SinOsc.kr(0.5, 0).range(b.first.bufnum + 0.1, b.last.bufnum - 0.1),
	[440, 441], 0, 0.2) }.play;
)
