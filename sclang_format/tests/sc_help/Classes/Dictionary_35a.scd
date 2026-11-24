// Source: Classes/Dictionary.schelp block 35 (part 1/3)
(
a = (
	pattern: Pbind(\note, Pgeom(1, 1.1, { 20.rand }), \dur, 0.05),
	embedInStream: { |event, inevent| event[\pattern].embedInStream(inevent) }
);
b = (note: [3, 5]);
c = (freq: 402, dur: 0.3);
Prand([a, b, c], inf).trace.play;
)
