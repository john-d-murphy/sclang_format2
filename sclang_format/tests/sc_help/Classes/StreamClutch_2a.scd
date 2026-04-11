// Source: Classes/StreamClutch.schelp block 2 (part 1/2)
(
var clutch, pat, decision;
pat = Pbind(\freq, Pseq([200, [300, 302], 400, 450], inf), \dur, 0.3);
b = StreamClutch(pat);
b.connected = false;
b.asEventStreamPlayer.play;
)
