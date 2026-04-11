// Source: Classes/Font.schelp block 1 (part 5/5)
(
var w, f, i = 0;

w = Window("Fonts", Rect(128, 64, 1024, 768));
b = ScrollView(w, w.view.bounds);

b.decorator = f = FlowLayout(b.bounds, Point(4,4), Point(4,2));

Font.availableFonts.do({ arg name;
	var v, s, n, spec, p, height = 16, font;
	font = Font(name,13);

		v = StaticText(b, Rect(0, 0, 120, height + 20));
		v.font = font;
		v.string = name;

		s = Button(b, Rect(0, 0, 140, height + 20));
		s.font = font;
		s.states = [[name]];
		s.action = { font.asCompileString.postln; };

		n = NumberBox(b, Rect(0, 0, 56, height + 20));
		n.font = font;
		n.object = pi;
	if( (i = i + 1) % 3 == 0,{
		f.nextLine;
	});
});

w.front;
)
