// Source: Classes/Font.schelp block 1 (part 4/5)
(
var w, f;

w = Window("Fonts", Rect(128, 64, 340, 360));
w.view.decorator = f = FlowLayout(w.view.bounds,Point(4, 4),Point(4, 2));

[
"Helvetica-Bold",
"Helvetica",
"Monaco",
"Arial",
"Gadget",
"MarkerFelt-Thin"
].do({ arg name;
	var v, s, n, spec, p, height = 16;

		v = StaticText(w, Rect(0, 0, 110, height + 20));
		v.font = Font(name, 13);
		v.string = name;

		s = Button(w, Rect(0, 0, 140, height + 20));
		s.font = Font(name, 13);
		s.states = [[name]];

		n = NumberBox(w, Rect(0, 0, 56, height + 20));
		n.font = Font(name, 13);
		n.object = pi;

	f.nextLine;
});

w.front;
)
