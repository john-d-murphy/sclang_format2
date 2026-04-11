// Source: Guides/Internal-Snooping.schelp block 3 (part 1/3)
(
// create some windows to snoop in
5.do { | i |
	var w, b;
	w = Window.new("snoop " ++ i.asString,
		Rect.new( 200 + 400.rand, 69 + 300.rand, 172, 90 ));
	w.front;
	b = Button.new( w, Rect.new( 23, 28, 127, 25 ));
	b.states = [["BLAM-O", Color.red]];
}
)
