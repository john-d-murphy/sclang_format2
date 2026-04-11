// Source: Classes/Font.schelp block 1 (part 3/5)
(
var updateFont;
w = Window("Fonts", Rect(150, Window.screenBounds.height - 500, 400, 400)).front;
w.view.decorator = FlowLayout(w.view.bounds);
StaticText.new(w, Rect(5, 0, 30, 20)).string_("Font").align_(\right);
m = PopUpMenu(w, Rect(40, 0, 250, 20));
m.items = Font.availableFonts;

StaticText.new(w, Rect(290, 0, 28, 20)).string_("Size").align_(\right);
y = PopUpMenu(w, Rect(322, 0, 50, 20));
y.items = ["6","7","8","9","10","12","13","14","18","24","36","48","60","72","96"];

t = TextView(w, Rect(10, 40, 380, 150));
t.string = "\nThe quick drowned fox jumped over the lazy blog. \n\n 0 1 2 3 4 5 6 7 8 9 ";

a = StaticText(w, 200@20).string_("The quick drowned fox").background_(Color.rand).align_(\center);
b = Button(w, 200@20).states_([["The quick drowned fox"]]).background_(Color.rand);
c = PopUpMenu(w, 200@20).items_(["The quick drowned fox"]).background_(Color.rand);

y.action = {
	var font;
	font = Font(m.items[m.value],y.items[y.value].asInteger);
	a.font_(font).refresh;
	b.font_(font).refresh;
	c.font_(font).refresh;
	t.font_(font).refresh;
};

m.action = y.action;

m.valueAction = 3;
y.valueAction = 5;
)
