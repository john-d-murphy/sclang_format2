// Source: Classes/Server.schelp block 15
(
s.bind {
	a = { |freq=100| SinOsc.ar(freq, LFTri.ar(freq)) * 0.2 }.play;
	s.sync;
	a.set(\freq, 400);
}
)
