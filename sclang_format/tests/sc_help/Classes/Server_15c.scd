// Source: Classes/Server.schelp block 15 (part 3/13)
(
s.makeBundle(2.0, {
	x = Synth.new("tpulse");
	a = Bus.control.set(440);
	x.map(\freq, a);
});
)
