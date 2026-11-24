// Source: Classes/EZPopUpMenu.schelp block 1 (part 1/7)
(

// many menus
// inherits the parent's decorator gap

(
w = Window.new("oscillators", Rect(200, 500, 200, 160)).front;
w.view.decorator = FlowLayout(w.view.bounds).gap_(2@2);
5.do{ |i|
	g = EZPopUpMenu.new(w, 190@22, "Oscillator % : ".format(i+1));
	g.addItem(\off, { "off".postln });
	g.addItem(\sine, { "sine".postln });
	g.addItem(\saw, { "saw".postln });
	g.addItem(\pulse, { "pulse".postln });
	g.setColors(Color.grey, Color.white);
	g.value = 0;
};
w.bounds = w.bounds.moveBy(300, 60);
);


// Creates its own window if parentView is nil:
(
g = EZPopUpMenu.new(nil, 250@22, " Select : ");
g.addItem(\item0, { "this is item 0".postln });
g.addItem(\item1, { "this is item 1".postln });
g.addItem(\item2, { "this is item 2".postln });
g.setColors(Color.grey, Color.white);
g.value = 0;

);

// layout vertical:
(
g = EZPopUpMenu.new(nil, 200@42, " Choose", layout: \vert);
g.addItem(\item0, { "this is item 0".postln });
g.addItem(\item1, { "this is item 1".postln });
g.addItem(\item2, { "this is item 2".postln });
g.setColors(Color.grey, Color.white);
g.window.bounds = g.window.bounds.moveBy(300, -200);
g.value = 0;
);

// No labelView created, so set the window title;
(
g = EZPopUpMenu.new(bounds: 180@22); // no label
g.addItem(\item0, { "this is item 0".postln });
g.addItem(\item1, { "this is item 1".postln });
g.addItem(\item2, { "this is item 2".postln });
g.value = 0;
g.window.name = " choose item";
g.window.bounds = g.window.bounds.moveBy(0, -200);
);
)
