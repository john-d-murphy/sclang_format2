// Source: Classes/EZPopUpMenu.schelp block 1 (part 4/7)
(
w = Window.new.front;
w.view.decorator = FlowLayout(w.view.bounds);
g = EZPopUpMenu.new(w, 200@22, "Menu:");
g.addItem(\item0, { "this is item 0".postln });
g.addItem(\item1, { "this is item 1".postln });
g.addItem(\item2, { "this is item 2".postln });
g.addItem(\item4, { "this is item 4".postln });
g.insertItem(3, \item3, { "this is item 3".postln });
g.value = 0;
)
