// Source: Classes/StreamClutch.schelp block 1 (part 2/2)
(
var clutch, pat, decision;
decision = Pseq([Pn(true,10), Prand([true, false], 10)], inf).asStream;
pat = Pbind(\freq, Pseq([200, [300, 302], 400, 450], inf), \dur, 0.3);
clutch = StreamClutch(pat, decision);
clutch.asEventStreamPlayer.play;
)
