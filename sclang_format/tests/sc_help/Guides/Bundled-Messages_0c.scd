// Source: Guides/Bundled-Messages.schelp block 0 (part 3/8)
(
s.makeBundle(2.0, {
	x = Synth.new("tpulse");
	a = Bus.control.set(440);
	x.map(\freq, a);
});
)
